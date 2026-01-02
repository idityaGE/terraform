# output "instance_id" {
#   description = "ID of the EC2 instgance"
#   value       = aws_instance.ec2_machine[*].id // many instances [count = 2]
#   # value       = aws_instance.ec2_machine.id  // single values
# }

output "ec2_public_ip" {
  description = "Public IP of e2c instance"
  # value       = aws_instance.ec2_machine[*].public_ip
  value = [
    for instance in aws_instance.ec2_machine : instance.public_ip
  ]
}
