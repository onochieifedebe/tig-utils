terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62.0"
    }
  }
}

variable "iam_user_name_prefix" {
  default = "tig_python_backend"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "tig-terraform-users" {
  count = 3
  name  = "${var.iam_user_name_prefix}_${count.index}"
}