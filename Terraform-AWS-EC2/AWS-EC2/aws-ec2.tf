terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.62.0"
    }
  }
}

# Define provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet in the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create a security group for the instance
resource "aws_security_group" "example_security_group" {
  name_prefix = "example_security_group"
  vpc_id      = aws_vpc.example_vpc.id

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
}

# Create a key pair for the instance
resource "aws_key_pair" "example_key_pair" {
  key_name   = "example_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnCvq7zH9M1e+vc96fE... example_key_pair"
}

# Create an EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  subnet_id     = aws_subnet.example_subnet.id

  tags = {
    Name = "example_instance"
  }
}
