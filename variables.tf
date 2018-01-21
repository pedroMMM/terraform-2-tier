#########
# General
#########
variable "region" {
  description = "AWS Region"
  default     = "us-east-2"
}

variable "application_name" {
  description = "The Application Name"
  default     = "2tier"
}

variable "environment_name" {
  description = "The Environment name"
  default     = "demo"
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
