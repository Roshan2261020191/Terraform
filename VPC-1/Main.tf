provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc"
  }
}

# Public Subnet in AZ-1
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, 0)
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet in AZ-2
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 2, 1)
  availability_zone = var.availability_zones[1]

  tags = {
    Name = "private-subnet"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet gateway"
  }
}

#Route table creation and internet gateway connection for public subnet
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id  # Use your existing VPC

  route {
    cidr_block = "0.0.0.0/0"               # All outbound traffic
    gateway_id = aws_internet_gateway.igw.id  # Use your existing IGW
  }

  tags = {
    Name = "public-rt"
  }
}

#Associate Route Table with public Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rtb.id

  depends_on = [aws_internet_gateway.igw]   # <-- this ensures IGW is created first
}

# Private Route Table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-subnet-rt"
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rtb.id
}

# dynamic AWS Security Group
resource "aws_security_group" "sg" {
  name        = var.sg
  description = "Security group with dynamic rules"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = var.sg
  }
}

resource "aws_security_group_rule" "inbound" {
  for_each          = { for idx, rule in var.inbound_rules : idx => rule }
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr]
  security_group_id = aws_security_group.sg.id
  description       = each.value.desc
}

resource "aws_security_group_rule" "outbound" {
  for_each          = { for idx, rule in var.outbound_rules : idx => rule }
  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr]
  security_group_id = aws_security_group.sg.id
  description       = each.value.desc
}