terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "my-vpc-sec-group" {
  name   = "my-vpc-sec-group"
  vpc_id = "vpc-02998dcdc7c929d3d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http-server-sg"
    env  = "Dev"
  }
}

resource "aws_instance" "http-server" {
  ami           = "ami-069aabeee6f53e7bf"
  key_name      = "http-server-key-pair"
  instance_type = "t2.micro"

  tags = {
    Name = var.ec2-name
  }

  vpc_security_group_ids = [aws_security_group.my-vpc-sec-group.id]
  subnet_id              = "subnet-03b9a9921f20e77ad"
}



