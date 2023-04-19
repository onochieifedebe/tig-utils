terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62.0"
    }
  }
}

# Define provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
# resource "aws_vpc" "example_vpc" {
#   cidr_block = "172.31.0.0/16"
# }

# Create a subnet in the VPC
# resource "aws_subnet" "example_subnet" {
#   vpc_id     = aws_vpc.example_vpc.id
#   cidr_block = "172.31.32.0/20"
# }

# Create a security group for the instance
resource "aws_security_group" "my_test_sg" {
  name_prefix = "devops_sg"
  vpc_id      = "vpc-040f30e4eca6d7402"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    mangedBy    = "terraform"
    environment = "dev"
  }
}

# Create a key pair for the instance
# resource "aws_key_pair" "example_key_pair" {
#   key_name   = "devops-key-pair"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnCvq7zH9M1e+vc96fE... example_key_pair"
# }

# Create an EC2 instance
resource "aws_instance" "my_ichie_instance" {
  ami                    = "ami-069aabeee6f53e7bf"
  instance_type          = "t2.micro"
  key_name               = "devops-key-pair"
  vpc_security_group_ids = [aws_security_group.my_test_sg.id]
  subnet_id              = "subnet-02193bafd5aca89e0"

  tags = {
    Name = "terraform_test_instance"
  }
}
