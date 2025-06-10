variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "eu-north-1"
}

variable "eu_north_availability_zone" {
  type        = list(string)
  description = "Availability zones"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC"
}

variable "subnet_count" {
  type        = number
  description = "How many subnets to create"
}
variable "eu_availability_zone" {
  description = "Availability zones"
  type        = list(string)
}
variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}
# Variable for allowed protocols (used for ingress)
variable "allowed_services" {
  description = "List of allowed services names (like ssh, http)"
  type        = list(string)
}
# Variable for port number mapping (HTTP = 80, HTTPS = 443, etc.)
variable "service_definitions" {
  description = "Map of service definitions with protocol and port"
  type = map(object({
    protocol = string
    port     = number
  }))
}




