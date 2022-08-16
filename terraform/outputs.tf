# print the public IP of the instance
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.code_server_public_ip.public_ip
}

# print the availability zone of the instance
output "availability_zones" {
  description = "Availability zones of Subnet and EC2 instance"
  value       = data.aws_availability_zones.available.names[0]
}
