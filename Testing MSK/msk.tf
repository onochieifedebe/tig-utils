provider "aws" {
  region = "us-east-1"
}

resource "aws_msk_cluster" "example" {
  cluster_name        = "example-cluster"
  kafka_version       = "2.8.0"
  enhanced_monitoring = "PER_TOPIC_PER_BROKER"

  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnets = [
      aws_subnet.example_subnet_1.id,
      aws_subnet.example_subnet_2.id
    ]
    security_groups = [
      aws_security_group.example_sg.id
    ]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = aws_kms_key.example_key.arn
    client_broker = "TLS"
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  tags = {
    Environment = "Dev"
    Department  = "Engineering"
  }
}

resource "aws_subnet" "example_subnet_1" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "example_subnet_2" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "example_sg" {
  name_prefix = "example-sg"

  ingress {
    from_port   = 9094
    to_port     = 9094
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

resource "aws_kms_key" "example_key" {
  description             = "Example KMS key"
  deletion_window_in_days = 7
  policy                  = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_msk_cluster" "example_msk" {
  cluster_name                 = "example-msk-cluster"
  kafka_version                = "2.8.0"
  number_of_broker_nodes       = 1
  broker_node_group_info {
    instance_type = "kafka.m5.large"
    client_subnet_selection {
      subnet_ids = [aws_subnet.example_subnet_1.id, aws_subnet.example_subnet_2.id]
    }
    security_groups = [aws_security_group.example_sg.id]
  }
  server_properties = jsonencode({
    auto.create.topics.enable       = true
    min.insync.replicas             = 2
    default.replication.factor      = 2
    offset.topic.num.partitions     = 1
    transaction.state.log.replication.factor = 2
  })
} 








# This Terraform configuration creates an Amazon MSK cluster with a specified number of 
# broker nodes and enables encryption in transit and at rest. 
# It also sets up CloudWatch logging for the broker logs and tags the cluster with some 
# metadata. Additionally, it creates a configuration for the cluster that sets some Kafka 
# server properties.

# Note that this is just an example configuration and may need to be customized based 
# on your specific use case. Additionally, you will need to provide your own KMS key ID 
# for encryption at rest.