variable "ami" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "terraform-ec2-key"
}
