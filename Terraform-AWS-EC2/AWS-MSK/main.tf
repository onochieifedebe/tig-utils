terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.62.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "terraform_msk_sg" {
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

resource "aws_iam_role" "msk_iam_role" {
  name = "msk-iam-connect"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "connect.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "msk_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaMSKExecutionRole"
  role       = aws_iam_role.msk_iam_role.name
}


resource "aws_msk_serverless_cluster" "terrraform_msk_cluster" {
  cluster_name = "terrraform-msk-cluster"

  vpc_config {
    subnet_ids = [
        "subnet-027f114e46d69e46e",
        "subnet-036e88d8f9ac2cb16",
        "subnet-0d69395ed1d9000ba" 
    ]
    security_group_ids = [aws_security_group.terraform_msk_sg.id]
  }

  client_authentication {
    sasl {
      iam {
        enabled = true
      }
    }
  }
}



