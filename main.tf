terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

resource "aws_key_pair" "ec2_ssh_key" {
  key_name   = "ssh-key"
  public_key = file("terra-key.pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # allow all ports
}

data "aws_ami" "my_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ec2_machine" {
  ami           = data.aws_ami.my_ubuntu.id
  count         = 1
  instance_type = "t3.micro"

  security_groups = [aws_security_group.allow_tls.name]
  key_name        = aws_key_pair.ec2_ssh_key.key_name

  root_block_device {
    volume_type = "gp3"
    volume_size = 15 # 15 GB
  }

  tags = {
    "name" = "just testing though terraform"
  }
}
