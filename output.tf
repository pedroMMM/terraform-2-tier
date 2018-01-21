################################
# Base URLs for each ECS Service
################################
output "ping_url" {
  description = "The DNS record for the ALB"
  value       = "${format("http://%s",module.ecs_service_ping.alb_dns)}"
}
