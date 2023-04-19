terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        versiversion = "~> 4.62.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}