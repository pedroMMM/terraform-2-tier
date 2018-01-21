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

################
# Aurora cluster
################
variable "aurora_engine" {
  description = "The Aurora Engine to use"
  default     = "aurora-postgresql"
}

variable "aurora_port" {
  description = "The port to use for the Aurora engine"
  default     = "5432"
}

variable "aurora_storage_encrypted" {
  description = "The boolean flag tha determines if the storage is encrypted"
  default     = true
}

variable "aurora_master_user" {
  description = "The username of the master User for the Aurora cluster"
  default     = "admin1"
}

variable "aurora_master_password" {
  description = "The password of the master User for the Aurora cluster"

  # This is just a place holder password, since it's only used for the initial 
  # create. After that it's can be modified.
  default = "admin1234"
}

variable "aurora_instance_count" {
  description = "The instance count of the Aurora cluster"

  default = 2
}

variable "aurora_instance_type" {
  description = "The instance type used by the Aurora cluster"

  default = "db.r4.large"
}

variable "aurora_preferred_backup_window" {
  description = "The preferred backup window by the Aurora cluster on UTC"

  default = "06:00-07:00"
}

variable "aurora_preferred_maintenance_window" {
  description = "The preferred maintenance window by the Aurora cluster on UTC"

  default = "sat:07:00-sat:08:00"
}

variable "aurora_apply_immediately" {
  description = "Are changes applied to the Aurora cluster immediately"

  default = true
}

variable "aurora_backup_retention_period" {
  description = "The backup retention period used by the Aurora cluster"

  default = 14
}
