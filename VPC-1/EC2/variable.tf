variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "vpc_id" {
  description = "ID of existing VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of existing public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of existing private subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID of existing security group"
  type        = string
}
