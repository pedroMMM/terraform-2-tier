################
# Aurora cluster
################
resource "aws_rds_cluster" "this" {
  cluster_identifier_prefix    = "${format("%s-cluster", var.application_name)}"
  master_username              = "${var.username}"
  master_password              = "${var.password}"
  port                         = "${var.port}"
  apply_immediately            = "${var.apply_immediately}"
  engine                       = "${var.engine}"
  storage_encrypted            = "${var.storage_encrypted}"
  final_snapshot_identifier    = "${format("%s-final", var.application_name)}"
  db_subnet_group_name         = "${var.db_subnet_group}"
  vpc_security_group_ids       = ["${aws_security_group.base_sg.id}"]
  backup_retention_period      = "${var.backup_retention_period}"
  preferred_backup_window      = "${var.preferred_backup_window}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
}

###################
# Cluster instances
###################
resource "aws_rds_cluster_instance" "cluster_instances" {
  count                        = "${var.instance_count}"
  identifier_prefix            = "${format("%s-instance", var.application_name)}"
  cluster_identifier           = "${aws_rds_cluster.this.id}"
  publicly_accessible          = false
  db_subnet_group_name         = "${var.db_subnet_group}"
  instance_class               = "${var.instance_type}"
  apply_immediately            = "${var.apply_immediately}"
  engine                       = "${var.engine}"
  preferred_maintenance_window = "${var.preferred_maintenance_window}"
  tags                         = "${var.tags}"
}

########################
# Cluster Security Group
########################
resource "aws_security_group" "base_sg" {
  name        = "${format("%s-Aurora-cluster", var.application_name)}"
  description = "${format("SG for the %s cluster DB instances", var.application_name)}"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.tags, map("Name", "${format("%s-cluster-SG", var.application_name)}"))}"
}

##############
# Ingress Rule
##############
resource "aws_security_group_rule" "allow_all_sql_in" {
  type                     = "ingress"
  from_port                = "${var.port}"
  to_port                  = "${var.port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.allowed_sg_id}"
  security_group_id        = "${aws_security_group.base_sg.id}"
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
  security_group_id = "${aws_security_group.base_sg.id}"
}
