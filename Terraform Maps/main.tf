terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.62.0"
    }
  }
}

variable "users" {
  default = {
    John: {
        role: "Developer"
        env: "Prod"
        }
    Tom: {
        role:"Developer"
        env: "Dev"
        }
    Jane: {
        role: "Administrator"
        env: "Test"
        }
  }
}

provider "aws" {
    region = "us-east-1"  
}

resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name = each.key
  tags = {
    env: each.value.env
    title: each.value.role
  }
}

