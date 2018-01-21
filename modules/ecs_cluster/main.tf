########################################
# AWS Key Pair for the ECS EC2 instances
########################################
resource "aws_key_pair" "key_pair" {
  key_name   = "${format("%s-ecs-key", var.application_name)}"
  public_key = "${file("${var.public_key_filename}")}"
}

#############
# ECS Cluster
#############
module "ecs_cluster" {
  source = "github.com/terraform-community-modules/tf_aws_ecs?ref=v5.0.0"

  name               = "${format("%s-cluster", var.application_name)}"
  vpc_id             = "${var.vpc_id}"
  subnet_id          = ["${var.subnet_ids}"]
  servers            = "${var.ecs_servers}"
  min_servers        = "${var.ecs_min_servers}"
  max_servers        = "${var.ecs_max_servers}"
  instance_type      = "${var.ecs_instance_type}"
  key_name           = "${aws_key_pair.key_pair.key_name}"
  security_group_ids = ["${aws_security_group.cluster_sg.id}"]
  heartbeat_timeout  = 30

  extra_tags = [
    {
      key                 = "Terraform"
      value               = "true"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment_name}"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "${var.application_name}"
      propagate_at_launch = true
    },
  ]
}

########################
# Cluster Security Group
########################
resource "aws_security_group" "cluster_sg" {
  name        = "${format("%s-ECS-cluster", var.application_name)}"
  description = "${format("SG for the %s ECS cluster instances", var.application_name)}"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.tags, map("Name", "${format("%s-ECS-cluster-SG", var.application_name)}"))}"
}

#############
# Egress Rule
#############
resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.cluster_sg.id}"
}

###############################
# The IAM Role for ECS services
###############################
resource "aws_iam_role" "ecs_service_role" {
  name = "${format("%s-cluster-ecs-service-role", var.application_name)}"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "ec2.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

####################################
# Custom IAM Policy for ECS services 
####################################
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name = "${format("%s-cluster-ecs-service-policy", var.application_name)}"
  role = "${aws_iam_role.ecs_service_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
