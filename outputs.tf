output "ec2_public_ip" {
  description = "Public IP Address assigned to EC2 Web Server"
  value       = aws_instance.my_ec2.public_ip
}