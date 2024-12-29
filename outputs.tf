output "ec2_instance_ids" {
  description = "IDs of all EC2 instances"
  value       = aws_instance.web[*].id
}

output "ec2_public_ips" {
  description = "Public IPs of all EC2 instances"
  value       = aws_instance.web[*].public_ip
}

output "security_group_details" {
  description = "Details of the security group"
  value = {
    id   = aws_security_group.web.id
    name = aws_security_group.web.name
    arn  = aws_security_group.web.arn
    url  = "https://console.aws.amazon.com/ec2/v2/home?region=${var.aws_region}#SecurityGroups:group-id=${aws_security_group.web.id}"
  }
}
