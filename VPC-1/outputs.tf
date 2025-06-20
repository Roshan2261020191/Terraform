output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "security_group_id" {
  description = "ID of the security group created"
  value       = aws_security_group.sg.id
}

output "aws_region" {
  description = "AWS region used in this module"
  value       = var.aws_region
}

output "availability_zones" {
  description = "AZs used in the subnets"
  value       = var.availability_zones
}
