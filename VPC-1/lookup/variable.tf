/*variable "aws_region" {
  description = "The AWS region to use"
  type        = string
}*/

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the existing public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the existing private subnet"
  type        = string
}

variable "security_group_id" {
  description = "ID of the existing security group"
  type        = string
}
