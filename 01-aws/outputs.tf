output "ec2_public_ip" {
  description = "value of the public ip of the ec2 instance"
  value       = aws_instance.server.public_ip
}

output "vpc_id" {
  description = "value of the vpc id"
  value       = aws_vpc.main.id
}

output "ami_id" {
  description = "value of the ami id"
  value       = aws_instance.server.ami
}
  
