provider "aws" {
    region= var.region
}

# VPC 
resource "aws_vpc" "my_vpc"{
    cidr_block= var.vpc_cidr_block
    tags={
        name= "${var.project}-vpc"
    }
}

# Public-sub 
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