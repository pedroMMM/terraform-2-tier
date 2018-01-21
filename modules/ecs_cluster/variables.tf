#########
# General
#########
variable "application_name" {
  description = "The Application Name"
  default     = ""
}

variable "environment_name" {
  description = "The Environment name"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

############
# Networking
############
variable "vpc_id" {
  description = "The VPC Id to deploy the cluster"
  default     = ""
}

variable "subnet_ids" {
  description = "The list of the Subnet Ids to deploy the EC2 instances"
  default     = []
  type        = "list"
}

#######################
# EC2 AutoScaling Group
#######################
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
  default     = ""
}
