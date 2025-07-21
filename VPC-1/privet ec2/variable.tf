variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance (e.g., t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Existing private subnet ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Existing public subnet ID (optional)"
  type        = string
}

variable "private_sg_name_id" {
  description = "Existing private security group ID"
  type        = string
}
variable "security_group_id" {
  description = "ID of the existing security group"
  type        = string
}
