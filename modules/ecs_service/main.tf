##################################
# Query the current AWS Account Id
##################################
data "aws_caller_identity" "current" {}

#################
# Local variables
#################################################
# The ECS Autoscaling defaults to the Linked Role 
# that was a very specific naming structure.
#################################################
locals {
  linked_autoscaling_role = "arn:aws:iam::%s:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

###########################
# Application Load Balancer
###########################
resource "aws_lb" "alb" {
  name            = "${format("%s-ALB", var.component_name)}"
  internal        = false
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = ["${var.subnet_ids}"]
  tags            = "${merge(var.tags, map("Name", "${format("%s-ALB", var.component_name)}"))}"
}

####################
# ALB Security Group
####################
resource "aws_security_group" "alb_sg" {
  name        = "${format("%s-ALB-SG", var.component_name)}"
  description = "Allows all traffic"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.tags, map("Name", "${format("%s-ALB-SG", var.component_name)}"))}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

###################
# ALB HTTP listener
###################
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.service_tg.arn}"
    type             = "forward"
  }

  depends_on = ["aws_lb_target_group.service_tg"]
}

#############
# ECS Service
#############
resource "aws_ecs_service" "service" {
  name                               = "${format("%s-service", var.component_name)}"
  cluster                            = "${var.ecs_cluster_arn}"
  task_definition                    = "${aws_ecs_task_definition.task.arn}"
  iam_role                           = "${var.ecs_service_role_arn}"
  desired_count                      = "${var.instance_target}"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.service_tg.arn}"
    container_name   = "${var.component_name}"
    container_port   = "${var.container_port}"
  }

  depends_on = ["aws_lb.alb"]
}

######################
# Base task definition
######################
resource "aws_ecs_task_definition" "task" {
  family = "${format("%s-task", var.component_name)}"

  container_definitions = <<EOF
[
    {
        "image": "${var.docker_image}",
        "name": "${var.component_name}",
        "cpu": ${var.container_cpu_limit},
        "memory": ${var.container_memory_limit},
        "essential": true,
        "portMappings": [
            {
                "containerPort": ${var.container_port},
                "hostPort": 0
            }
        ]
    }
]
EOF
}

############################################
# ECS Service Target Group Autoscaling Rules 
############################################
resource "aws_appautoscaling_target" "target" {
  resource_id        = "${format("service/%s/%s", var.ecs_cluster_name, aws_ecs_service.service.name)}"
  role_arn           = "${format(local.linked_autoscaling_role, data.aws_caller_identity.current.account_id)}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = "${var.instance_min}"
  max_capacity       = "${var.instance_max}"
  service_namespace  = "ecs"
  depends_on         = ["aws_ecs_service.service"]
}

##########################
# ECS Service Target Group
##########################
resource "aws_lb_target_group" "service_tg" {
  name = "${format("%s-TG", var.component_name)}"

  protocol = "HTTP"
  port     = 80
  vpc_id   = "${var.vpc_id}"

  deregistration_delay = "30"

  health_check {
    path = "${var.health_path}"
  }

  tags = "${merge(var.tags, map("Name", "${format("%s-TG", var.component_name)}"))}"
}
