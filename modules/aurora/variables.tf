#########
# General
#########
variable "application_name" {
  description = "The Application Name"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to resources"
  default     = {}
}

############
# Networking
############
variable "vpc_id" {
  description = "The Id of the VPC to associate with the cluster"
  default     = ""
}

variable "db_subnet_group" {
  description = "The Id of the DB subnet group to associate with the cluster"
  default     = ""
}

variable "allowed_sg_id" {
  description = "The Security Group Id that is allowed for ingress in the Aurora cluster"
  default     = ""
}

##########
# Database
##########
variable "engine" {
  description = "The Aurora Engine to use"
  default     = ""
}

variable "port" {
  description = "The port to use for the Aurora engine"
  default     = ""
}

variable "storage_encrypted" {
  description = "The boolean flag tha determines if the storage is encrypted"
  default     = true
}

variable "username" {
  description = "The master username"
  default     = ""
}

variable "password" {
  description = "The master password"
  default     = ""
}

variable "instance_count" {
  description = "The number of instances in the Aurora cluster"
  default     = 0
}

variable "instance_type" {
  description = "The type of instances in the Aurora cluster"
  default     = ""
}

variable "preferred_backup_window" {
  description = "The preferred backup window"
  default     = ""
}

variable "preferred_maintenance_window" {
  description = "The preferred maintenance window"
  default     = ""
}

variable "apply_immediately" {
  description = "The boolean flag that determines if the changes to the cluster are applied immediately or on the next maintenance window"
  default     = false
}

variable "backup_retention_period" {
  description = "The boolean flag that determines if the changes to the cluster are applied immediately or on the next maintenance window"
  default     = 1
}
