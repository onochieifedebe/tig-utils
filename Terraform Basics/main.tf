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

resource "aws_s3_bucket" "tig-bucket-demo1" {
  bucket = "tig-front-dev-bucket-1"

  tags = {
    Name        = "TIG Front Dev Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "tig-versioning" {
    bucket = aws_s3_bucket.tig-bucket-demo1.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_iam_user" "tig_iam_user" {
  name = "terraform-user-onochie"
}



