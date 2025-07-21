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
  key_name   = "private-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/private-key.pem"
  file_permission      = "0400"
  directory_permission = "0700"
}

# Reference lookup module to fetch existing VPC/subnet/SG
module "lookup" {
  source = "git::https://github.com/Roshan2261020191/Terraform.git//VPC-1/lookup?ref=main"

  vpc_id             = var.vpc_id
  public_subnet_id   = var.public_subnet_id
  private_subnet_id  = var.private_subnet_id
  private_sg_name_id = var.private_sg_name_id  
  security_group_id   = var.security_group_id  
}



# Launch EC2 instance in existing private subnet
resource "aws_instance" "private_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = module.lookup.private_subnet_id
  vpc_security_group_ids = [module.lookup.security_group_id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "private-ec2"
  }
}

# Output (this will be null since it's a private subnet)
output "instance_public_ip" {
  value       = aws_instance.private_instance.public_ip
  description = "Public IP of the EC2 instance (null in private subnet)"
}
