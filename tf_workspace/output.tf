
output "azs" {
  description = "ID of the EC2 instance AMI"
  value       = data.aws_availability_zones.available_azs
}

output "ec2_IP" {
  description = "Instance IP"
  value       = aws_instance.app_server.public_ip
}