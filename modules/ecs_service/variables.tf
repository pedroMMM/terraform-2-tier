#########
# General
#########
variable "component_name" {
  description = "The Component name"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

############
# NetWorking
############
variable "vpc_id" {
  description = "The id of the VPC"
  default     = ""
}

variable "subnet_ids" {
  description = "List of public subnet ids for the ALB to spawn across"
  default     = []
}

#############
# ECS Cluster
#############
variable "ecs_cluster_arn" {
  description = "Target ECS cluster ARN"
  default     = ""
}

variable "ecs_cluster_name" {
  description = "Target ECS cluster name"
  default     = ""
}

variable "ecs_service_role_arn" {
  description = "The ARN of the ECS Service Role"
  default     = ""
}

#############
# ECS Service
#############
variable "instance_target" {
  description = "Number of ideal target replicas"
  default     = ""
}

variable "instance_min" {
  description = "Number of minimum target replicas"
  default     = ""
}

variable "instance_max" {
  description = "Number of maximum target replicas"
  default     = ""
}

variable "container_port" {
  description = "Application port in the Docker container"
  default     = ""
}

##########
# ECS Task
##########
variable "docker_image" {
  description = "The docker image for the ECS Task"
  default     = ""
}

variable "health_path" {
  description = "Relative URL for application health check"
  default     = ""
}

variable "container_cpu_limit" {
  description = "The CPU limit for the docker container, 1 CPU = 1024"
  default     = ""
}

variable "container_memory_limit" {
  description = "The memory limit for the docker container"
  default     = ""
}
