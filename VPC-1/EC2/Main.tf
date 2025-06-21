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

# Call VPC module from parent folder
module "vpc" {
  source ="git::https://github.com/Roshan2261020191/Terraform.git//VPC-1?ref=main"
}

# Launch EC2 instance
resource "aws_instance" "public_instance" {
   ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id              = module.vpc.public_subnet_id
  vpc_security_group_ids = [module.vpc.sg_id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "public-ec2"
  }
}

# Output public IP
output "instance_public_ip" {
  value = aws_instance.public_instance.public_ip
}
