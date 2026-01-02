terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
}

provider "aws" {
  profile = "localstack"
  region  = "us-east-1"
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

resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
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

# chmod 600 ./terra-key
# ssh -i ./terra-key root@ec2-172-17-0-3.localhost.localstack.cloud
resource "aws_instance" "ec2_machine" {
  # count = 2 # meta argument
  # or
  for_each = tomap({
    "my_instance_1" = "t2.micro"
    "my_instance_2" = "t3.micro"
  })

  depends_on = [aws_key_pair.ec2_ssh_key, aws_security_group.allow_tls]

  ami           = "ami-df5de72bdb3b" # https://docs.localstack.cloud/aws/services/ec2/
  instance_type = each.value

  security_groups = [aws_security_group.allow_tls.name]
  key_name        = aws_key_pair.ec2_ssh_key.key_name


  user_data = file("install_nginx.sh")

  root_block_device {
    volume_type = "gp3"
    volume_size = var.env == "PRD" ? 10 : var.root_storage_size # GB
  }

  tags = {
    "name" = each.value
  }
}
