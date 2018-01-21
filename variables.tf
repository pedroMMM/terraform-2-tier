#########
# General
#########
variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "application_name" {
  description = "The Application Name"
  default     = "twotier"
}

variable "environment_name" {
  description = "The Environment name"
  default     = "demo"
}

#####
# VPC
#####
variable "vpc_cidr" {
  description = "The CIDR for the VPC IP block"
  default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  description = "The CIDR for the private Subnets IP block"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets_cidr" {
  description = "The CIDR for the public Subnets IP block"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "database_subnets_cidr" {
  description = "The CIDR for the database Subnets IP block"
  default     = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
}

#############
# ECS Cluster
#############
variable "ecs_servers" {
  description = "The number of default servers in the ECS Cluster"
  default     = 2
}

variable "ecs_min_servers" {
  description = "The minimum number of servers in the ECS Cluster"
  default     = 2
}

variable "ecs_max_servers" {
  description = "The maximum number of servers in the ECS Cluster"
  default     = 2
}

variable "ecs_instance_type" {
  description = "The maximum number of servers in the ECS Cluster"
  default     = "t2.medium"
}

variable "public_key_filename" {
  description = "The EC2 instance public key filename"
  default     = "~/.ssh/id_rsa.pub"
}
