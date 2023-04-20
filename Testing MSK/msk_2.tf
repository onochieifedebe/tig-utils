provider "aws" {
  region = "us-east-1"
}

resource "aws_msk_cluster" "example" {
  cluster_name               = "example-cluster"
  kafka_version              = "2.8.0"
  number_of_broker_nodes     = 3
  enhanced_monitoring_level  = "PER_BROKER"
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled         = true
        log_group_name  = "/aws/msk/example-cluster-broker-logs"
        retention_in_days = 14
      }
    }
  }
}

resource "aws_msk_connect" "example" {
  name               = "example-connect"
  service_execution_role_arn = aws_iam_role.example.arn
  kafka_cluster_arn  = aws_msk_cluster.example.arn
}

resource "aws_iam_role" "example" {
  name = "example-msk-connect"
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

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonMSKConnectServiceRolePolicy"
  role       = aws_iam_role.example.name
}
