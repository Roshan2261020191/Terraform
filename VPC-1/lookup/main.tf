/*provider "aws" {
  region = var.aws_region
}*/

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  id = var.public_subnet_id
}

data "aws_subnet" "private" {
  id = var.private_subnet_id
}

data "aws_security_group" "sg" {
  id = var.security_group_id
}
data "aws_security_group" "private_sg_name" {
  id = var.private_sg_name_id
}
