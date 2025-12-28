variable "instance_name" {
  description = "Value of the intsnace name"
  type        = string
  default     = "My_tf_instance"
}

variable "ec2_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "a1.medium"
}
