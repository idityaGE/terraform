provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_instance" "tf-instance" {
  ami           = ""
  instance_type = var.ec2_instance_type

  tags = {
    "name" = var.instance_name
  }
}
