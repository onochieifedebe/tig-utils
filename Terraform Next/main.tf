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

variable "user_names" {
    default = ["onochie", "casey", "diego"]
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "tig-terraform-users" {
  count = length(var.user_names)
  name  = "${var.iam_user_name_prefix}_${var.user_names[count.index]}"
}

resource "aws_iam_group" "tig_python_group" {
  name = "TIG-BackEnd-Python-Group"
}

resource "aws_iam_group_membership" "python_team" {
  count = length(var.user_names)  
  name = "Python-Team"

  users = [
    "${var.iam_user_name_prefix}_${var.user_names[count.index]}"
  ]
  

  group = aws_iam_group.tig_python_group.name
}