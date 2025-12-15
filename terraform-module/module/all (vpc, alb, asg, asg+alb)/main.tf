provider "aws" {
    region = var.region
}

#vpc
# VPC 
resource "aws_vpc" "my_vpc"{
    cidr_block= var.vpc_cidr_block
    tags={
        name= "${var.project}-vpc"
    }
}

# Public-sub 1
resource "aws_subnet" "public_sub"{
    vpc_id= aws_vpc.my_vpc.id
    cidr_block= var.public_sub_cidr
    availability_zone = var.az1
    map_public_ip_on_launch= true
    tags={
        name= "${var.project}-public_sub"
    }
}

#public-sub 2
resource "aws_subnet" "public_sub_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_sub2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public-sub-2"
  }
}


#Private-sub
resource "aws_subnet" "private_sub"{
    vpc_id= aws_vpc.my_vpc.id
    cidr_block= var.private_sub_cidr
    availability_zone = var.az3
    #map_public_ip_on_launch= true
    tags={
        name= "${var.project}-private_sub"
    }
}

#IGW
resource "aws_internet_gateway" "my_igw"{
    vpc_id = aws_vpc.my_vpc.id
    tags={
        name= "${var.project}-my-igw"
    }
}

#EIP
resource "aws_eip" "Elastic_IP" {
    domain = "vpc"
}

#NAT
resource "aws_nat_gateway" "my_nat" {
    subnet_id = aws_subnet.public_sub.id
    allocation_id = aws_eip.Elastic_IP.id
  
}

#Main/default route-table
resource "aws_default_route_table" "my_rt_default" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

#secondary rt for private-sub
resource "aws_route_table" "my_rt_sub" {
  vpc_id =  aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat.id
  }
}

#Associate public-sub to main/default rt
resource "aws_route_table_association" "public_rt_associate" {
  subnet_id      = aws_subnet.public_sub.id
  route_table_id = aws_default_route_table.my_rt_default.id
}

#Associate private-sub to sub/secondary rt
resource "aws_route_table_association" "private_rt_associate" {
  subnet_id      = aws_subnet.private_sub.id
  route_table_id = aws_route_table.my_rt_sub.id
}




#asg
#SG-asg
resource "aws_security_group" "asg_sg" {
  name= "${var.project}-asg-sg"
  description = "Allows http of instance"
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project}-asg-sg"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Launch template-instance1
resource "aws_launch_template" "template_1" {
  name_prefix = var.name1
  image_id = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.asg_sg.id
  ]
  tags = {
    Name = "${var.project}-pub-inst"
  }
}

#AutoScaling group frontend
resource "aws_autoscaling_group" "asg_fe" {
  name = "${var.project}-asg-fe"
  vpc_zone_identifier = [aws_subnet.public_sub.id]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  
  launch_template {
    id      = aws_launch_template.template_1.id
    version = "$Latest"
  }
}

#launch Template-instance2
resource "aws_launch_template" "template_2" {
  name_prefix = var.name2
  image_id = var.ami_id
  instance_type =var.instance_type
  vpc_security_group_ids = [
    aws_security_group.asg_sg.id
  ]
  tags = {
    Name = "${var.project}-pri-inst"
  }
}

#ASG backend
resource "aws_autoscaling_group" "asg_be" {
  name = "${var.project}-asg-be"
  vpc_zone_identifier = [aws_subnet.private_sub.id]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.template_2.id
    version = "$Latest"
  }
}

# ASG+ALB frontend attachment
resource "aws_autoscaling_attachment" "asg_to_alb_fe" {
  autoscaling_group_name = aws_autoscaling_group.asg_fe.id
  lb_target_group_arn    = aws_lb_target_group.my_tg.arn

  depends_on = [aws_lb_target_group.my_tg] # this block applies after tg is created
}
#ASG+ALB backend attachment
resource "aws_autoscaling_attachment" "asg_to_alb_be" {
  autoscaling_group_name = aws_autoscaling_group.asg_be.id
  lb_target_group_arn    = aws_lb_target_group.my_tg.arn

  depends_on = [aws_lb_target_group.my_tg]# this block applies after tg is created
}



#alb
# SG for Alb
resource "aws_security_group" "alb_sg" {
  name= "${var.project}-alb-sg"
  description= "Allows http from alb"
  vpc_id = aws_vpc.my_vpc.id
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
  vpc_id = aws_vpc.my_vpc.id
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
    aws_subnet.public_sub.id,
    aws_subnet.public_sub_2.id
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