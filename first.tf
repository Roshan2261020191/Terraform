# VPC Creation
provider "aws" {
  region = var.aws_region
}



resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "dev-proj-1-vpc"
  }
}


#subnet creation
locals {
  subnet_cidr_blocks = [
    for i in range(0, 2) :
    cidrsubnet(var.vpc_cidr, 8, i)
  ]
}
# AWS Subnet resource to create subnets
resource "aws_subnet" "subnet" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.subnet_cidr_blocks[count.index]
  availability_zone = var.eu_north_availability_zone[count.index]

  map_public_ip_on_launch = count.index == 0 ? true : false
  # Define the type (Public or Private) based on the index
  tags = {
    Name = count.index == 0 ? "Public Subnet" : "Private Subnet"
    Type = count.index == 0 ? "Public" : "Private"
  }
}


#internet gateway creation
resource "aws_internet_gateway" "IGT" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet gateway"
  }
}


#Route table creation
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Allows outbound traffic to any destination (public internet)
    gateway_id = aws_internet_gateway.IGT.id
  }
}
#associate route table to the subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnet[0].id # This is your Public Subnet
  route_table_id = aws_route_table.public_route.id
}


# Create a Security Group with dynamic ingress rules for the allowed ports 
resource "aws_security_group" "public_sg" {
  name        = var.security_group_name
  description = "Allow inbound traffic for selected protocols and fixed egress"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "ingress" {
  count = length(var.allowed_services)
  type  = "ingress"
# Dynamic Port Mapping based on protocol type
  from_port   = var.service_definitions[var.allowed_services[count.index]].port
  to_port     = var.service_definitions[var.allowed_services[count.index]].port
  protocol    = var.service_definitions[var.allowed_services[count.index]].protocol

  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}
# Static Egress Rule - Allow all outbound traffic
resource "aws_security_group_rule" "egress" {
  type         = "egress"
  from_port    = 0
  to_port      = 0
  protocol     = "-1"
  cidr_blocks  = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}







