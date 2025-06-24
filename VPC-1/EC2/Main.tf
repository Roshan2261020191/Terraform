provider "aws" {
  region = var.aws_region
}

# Generate an SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair using the public key
resource "aws_key_pair" "generated_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/terraform-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

# Reference lookup module from GitHub (uses existing VPC resources)
module "lookup" {
  source = "git::https://github.com/Roshan2261020191/Terraform.git//VPC-1/lookup?ref=main"

  aws_region         = var.aws_region
  vpc_id             = var.vpc_id
  public_subnet_id   = var.public_subnet_id
  private_subnet_id  = var.private_subnet_id
  security_group_id  = var.security_group_id

}

# Launch EC2 instance in existing public subnet
resource "aws_instance" "public_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = module.lookup.public_subnet_id
  vpc_security_group_ids = [module.lookup.security_group_id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "public-ec2"
  }
}

# Output EC2 public IP
output "instance_public_ip" {
  value       = aws_instance.public_instance.public_ip
  description = "Public IP of the EC2 instance"
}
