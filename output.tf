##########################
# Aurora Cluster Endpoints
##########################
output "aurora_write_endpoint" {
  description = "The URL of write Aurora endpoint"
  value       = "${module.aurora_cluster.write_endpoint}"
}

output "aurora_read_endpoint" {
  description = "The URL of read Aurora endpoint"
  value       = "${module.aurora_cluster.read_endpoint}"
}

################################
# Base URLs for each ECS Service
################################
output "ping_url" {
  description = "The DNS record for the ALB"
  value       = "${format("http://%s",module.ecs_service_ping.alb_dns)}"
}
