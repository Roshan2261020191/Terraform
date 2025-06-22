variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of 2 AZs for public and private subnets"
}

variable "sg" {
  type = string
}

variable "inbound_rules" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
    desc      = string
  }))
  default = []  #  Important during module usage – allows module to work even if no rules are passed
}
variable "outbound_rules" {
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
    desc      = string
  }))
  default = []  # Important during module usage – allows module to work even if no rules are passed
}



