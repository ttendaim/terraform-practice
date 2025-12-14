
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "demo" {
  ami             = "ami-004e960cde33f9146"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.rule.name]

  tags = {
    Name = "DemoInstance"
  }
}

resource "aws_security_group" "rule" {
  name        = "global"
  description = "Allow SSH inbound traffic"

}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rule.id
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rule.id
}

resource "local_file" "text" {
  content  = "123 testing"
  filename = "counting.txt"
}