output "vpc_id" {
  value       = data.aws_vpc.main.id
  description = "Existing VPC ID"
}

output "public_subnet_id" {
  value       = data.aws_subnet.public.id
  description = "Public Subnet ID"
}

output "private_subnet_id" {
  value       = data.aws_subnet.private.id
  description = "Private Subnet ID"
}

output "security_group_id" {
  value       = data.aws_security_group.sg.id
  description = "Security Group ID"
}
