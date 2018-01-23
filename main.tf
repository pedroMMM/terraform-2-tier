############################
# AWS Provider configuration
############################
provider "aws" {
  version = "~> 1.7"
  region  = "${var.region}"
}

###############################################
# Query the AZs available in the current Region
###############################################
data "aws_availability_zones" "azs" {}

#################
# Local variables
#################
locals {
  tags = {
    Terraform   = "true"
    Environment = "${var.environment_name}"
    Application = "${var.application_name}"
  }
}

##########################################
# VPC to house the DB and the ECS Clusters
##########################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 1.15.0"

  name                         = "${format("%s-vpc", var.application_name)}"
  cidr                         = "${var.vpc_cidr}"
  azs                          = ["${data.aws_availability_zones.azs.names}"]
  private_subnets              = ["${var.private_subnets_cidr}"]
  public_subnets               = ["${var.public_subnets_cidr}"]
  database_subnets             = ["${var.database_subnets_cidr}"]
  create_database_subnet_group = true
  enable_nat_gateway           = true
  enable_dns_support           = true
  tags                         = "${local.tags}"
}

#########################################
# ECS Cluster and cluster level resources
#########################################
module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  application_name    = "${var.application_name}"
  environment_name    = "${var.environment_name}"
  vpc_id              = "${module.vpc.vpc_id}"
  subnet_ids          = "${module.vpc.private_subnets}"
  ecs_servers         = "${var.ecs_servers}"
  ecs_min_servers     = "${var.ecs_min_servers}"
  ecs_max_servers     = "${var.ecs_max_servers}"
  ecs_instance_type   = "${var.ecs_instance_type}"
  public_key_filename = "${var.public_key_filename}"
  tags                = "${local.tags}"
}

################
# Aurora cluster
################
module "aurora_cluster" {
  source = "./modules/aurora"

  application_name             = "${var.application_name}"
  vpc_id                       = "${module.vpc.vpc_id}"
  db_subnet_group              = "${module.vpc.database_subnet_group}"
  allowed_sg_id                = "${module.ecs_cluster.ecs_cluster_sg}"
  engine                       = "${var.aurora_engine}"
  port                         = "${var.aurora_port}"
  storage_encrypted            = "${var.aurora_storage_encrypted}"
  username                     = "${var.aurora_master_user}"
  password                     = "${var.aurora_master_password}"
  instance_count               = "${var.aurora_instance_count}"
  instance_type                = "${var.aurora_instance_type}"
  preferred_backup_window      = "${var.aurora_preferred_backup_window}"
  preferred_maintenance_window = "${var.aurora_preferred_maintenance_window}"
  apply_immediately            = "${var.aurora_apply_immediately}"
  backup_retention_period      = "${var.aurora_backup_retention_period}"
  tags                         = "${local.tags}"
}

###################
# ECS Service: Ping
###################
module "ecs_service_ping" {
  source = "./modules/ecs_service"

  component_name         = "ping"
  tags                   = "${local.tags}"
  vpc_id                 = "${module.vpc.vpc_id}"
  subnet_ids             = "${module.vpc.public_subnets}"
  ecs_cluster_arn        = "${module.ecs_cluster.ecs_cluster_arn}"
  ecs_cluster_name       = "${module.ecs_cluster.ecs_cluster_name}"
  ecs_service_role_arn   = "${module.ecs_cluster.ecs_service_role_arn}"
  instance_target        = "2"
  instance_min           = "2"
  instance_max           = "4"
  container_port         = 80
  docker_image           = "pedrommm/simple-ping:latest"
  health_path            = "/ping.html"
  container_cpu_limit    = 128
  container_memory_limit = 256
}
