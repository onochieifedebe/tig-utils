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

# Create a new Lambda function
resource "aws_lambda_function" "example_lambda" {
  function_name    = "example_lambda"
  runtime          = "nodejs14.x"
  handler          = "index.handler"
  role             = aws_iam_role.example_lambda_role.arn
  filename         = "example_lambda.zip"
  source_code_hash = filebase64sha256("example_lambda.zip")

  # Define the Lambda function's environment variables
  environment {
    variables = {
      EXAMPLE_VAR = "example_value"
    }
  }

  # Define the Lambda function's configuration settings
  timeout         = 60
  memory_size     = 128
  reserved_concurrent_executions = 10

  # Define the Lambda function's event triggers
  # For example, an S3 bucket can be used as an event trigger for a Lambda function
  # You can add more event triggers by defining additional resource blocks
  event_source_mappings {
    event_source_arn = aws_s3_bucket.example_bucket.arn
    batch_size       = 1
  }
}

# Create a new IAM role for the Lambda function
resource "aws_iam_role" "example_lambda_role" {
  name = "example_lambda_role"

  # Define the IAM role's policy document
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach an IAM policy to the Lambda function's role
resource "aws_iam_role_policy_attachment" "example_lambda_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.example_lambda_role.name
}

# Create an S3 bucket that can be used as an event trigger for the Lambda function
resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}
