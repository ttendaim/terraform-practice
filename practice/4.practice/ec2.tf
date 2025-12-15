#1. Security for ALB ( Internet -> ALB)

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = aws_vpc.custom_vpc.id

  tags = {
    Name = "alb-sg"
  }

}

resource "aws_security_group_rule" "alb_internet_ingress" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]

}

resource "aws_security_group_rule" "alb_engress" {
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

#2 Security group for EC2 (ALB -> EC2)

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = " SG for ec2 websever instance"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-sg"
  }
}


# 3 Application load balance 

resource "aws_lb" "app_lb" {

  name               = "app-lb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnet[*].id
  depends_on         = [aws_internet_gateway.igw]

}

# Target group for alb
resource "aws_lb_target_group" "alb_ec2_tg" {
  name     = "web-server-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
  tags = {
    Name = "alb-ec2-target-group"
  }
}

resource "aws_lb_listener" "alb_listner" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_ec2_tg.arn
  }

  tags = {
    Name = " alb_ listener"
  }
}

# launch template for ec2 instance

resource "aws_launch_template" "web_server_lt" {
  instance_type = "t2.micro"
  image_id      = "ami-015f3aa67b494b27e"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }
  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from $(hostname -f)" > /var/www/html/index.html
EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server-instance"
    }
  }
}

# Auto scaling group for ec2 instance

resource "aws_autoscaling_group" "web_server" {
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  name                = "webserver-asg"
  target_group_arns   = [aws_lb_target_group.alb_ec2_tg.arn]
  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"

  }

  health_check_type = "EC2"

}


output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}