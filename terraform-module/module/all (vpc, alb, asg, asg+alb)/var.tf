#vpc
variable "vpc_cidr_block" {
    default = "10.0.0.0/16"
}
variable "public_sub_cidr" {
    default = "10.0.0.0/24"
}
variable "public_sub2_cidr" {
    default = "10.0.5.0/24"
}
variable "private_sub_cidr" {
    default = "10.0.10.0/24"
}

#asg
variable "region" {
    default = "ap-south-1"
}
variable "ami_id" {
    default = "ami-02b8269d5e85954ef"
}
variable "instance_type" {
    default = "t3.micro"
}
variable "name1" {
    default = "inst-1"
}
variable "name2" {
    default = "inst-2"
}
variable "az1" {
    default = "ap-south-1a"
}
variable "az2" {
    default = "ap-south-1b"
}
variable "az3" {
    default = "ap-south-1b"
}
variable "project" {
    default = "tf"
}


#alb
