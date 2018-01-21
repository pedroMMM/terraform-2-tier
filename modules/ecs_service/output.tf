#####
# ALB
#####
output "alb_dns" {
  description = "The DNS record for the ALB"
  value       = "${aws_lb.alb.dns_name}"
}
