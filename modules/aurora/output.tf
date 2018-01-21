##################
# Aurora Endpoints
##################
output "write_endpoint" {
  description = "The URL of write Aurora endpoint"
  value       = "${aws_rds_cluster.this.endpoint}"
}

output "read_endpoint" {
  description = "The URL of read Aurora endpoint"
  value       = "${aws_rds_cluster.this.reader_endpoint}"
}
