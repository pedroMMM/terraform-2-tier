################
# ECS Identifers
################
output "ecs_cluster_arn" {
  description = "The ARN of the ECS Service Role"
  value       = "${module.ecs_cluster.cluster_id}"
}

output "ecs_cluster_name" {
  description = "The ARN of the ECS Service Autoscaling Role"
  value       = "${format("%s-cluster", var.application_name)}"
}

######################
# ECS Cluster AIM Role
######################
output "ecs_service_role_arn" {
  description = "The ARN of the ECS Service Role"
  value       = "${aws_iam_role.ecs_service_role.arn}"
}

##########################
# ECS Cluster Instances SG
##########################
output "ecs_cluster_sg" {
  description = "The SG of the ECS cluster instances"
  value       = "${aws_security_group.cluster_sg.id}"
}
