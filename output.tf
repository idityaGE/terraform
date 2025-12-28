output "instance_id" {
  description = "ID of the EC2 instgance"
  value       = aws_instance.ec2_machine.id
}

output "ec2_public_ip" {
  description = "Public IP of e2c instance"
  value       = aws_instance.ec2_machine.public_ip
}
