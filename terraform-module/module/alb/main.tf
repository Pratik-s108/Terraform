provider "aws" {
  region= var.region
}

# SG for Alb
resource "aws_security_group" "alb_sg" {
  name= "${var.project}-alb-sg"
  description= "Allows http from alb"
  vpc_id = module.aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project}-alb-sg"
  }

  ingress {     #inbound rules
    from_port= 80
    to_port= 80
    protocol= "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {      #Outbound rules
    from_port= 0
    to_port= 0
    protocol= "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Tagrget-group
resource "aws_lb_target_group" "my_tg" {
  name = "${var.project}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = module.aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project}-tg"
  }
}

# ALB
resource "aws_lb" "my_alb" {
  name = "${var.project}-alb"
  internal = false
  load_balancer_type = "application"
  subnets            = [
    module.vpc.aws_subnet.public_sub.id,
    module.vpc.aws_subnet.public_sub_2.id
  ]
  security_groups = [aws_security_group.alb_sg.id]
  tags = {
    Name = "${var.project}-lb"
  }
}

#Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }
}

resource "aws_lb_listener_rule" "mobile" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {

    
    type = "forward"
    target_group_arn = aws_lb_target_group.my_tg.arn
  }

  condition {
    path_pattern {
      values = ["/mobile*"]
    }
  }
}