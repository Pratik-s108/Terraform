# VPC module-variables
variable "region" {    # comman in all
  default = "ap-south-1"
}
variable "project" {    # comman in all
  default = "Terraform"
}
variable "az1" {
  default = "ap-south-1a"
}
variable "az2" {
  default = "ap-south-1b"
}
variable "az3" {
  default = "ap-south-1c"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_cidr" {
  default = "10.0.0.0/20"
}
variable "public2_cidr" {
  default = "10.0.5.0/20"
}
variable "private_cidr" {
  default = "10.0.16.0/20"
}

# ASG module-variables
variable "name1" {
  default = "Frontend"
}
variable "name2" {
  default = "Backend"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "ami_id" {
  default = "ami-02b8269d5e85954ef"
}

# RDS module-variable
variable "GB" {
  default = 20
}
variable "db_name" {
  default = "my_db"
}
variable "engine_name" {
  default = "mariadb"
}
variable "engine_version" {
  default = "11.4.8"
}
variable "instance_class" {
  default = "db.t4g.micro"
}
variable "username" {
  default = "pratik"
}
variable "password" {
  default = "123"
}
variable "parameter_group_name" {
  default = "default.mysql8.0"
}

# IAM module-variable
variable "user1_iam" {
  default = "user1"
}
variable "iam_policy_name" {
  default = "user1"
}
variable "user2_iam" {
  default = "user2"
}
variable "iam_policy_arn" {
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}