output "aws_security_group_http_server_details" {
  value = aws_security_group.my-vpc-sec-group
}

output "aws_instance_details" {
  value = aws_instance.http-server
}