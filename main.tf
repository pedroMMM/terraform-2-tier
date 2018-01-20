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
    Environment = "demo"
    Application = "${var.application_name}"
  }
}

##########################################
# VPC to house the DB and the ECS Clusters
##########################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 1.15.0"

  name = "${format("%s-vpc", var.application_name)}"
  cidr = "10.0.0.0/16"

  azs              = ["${data.aws_availability_zones.azs.names}"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

  create_database_subnet_group = true
  enable_nat_gateway           = true
  enable_dns_support           = true

  tags = "${local.tags}"
}
