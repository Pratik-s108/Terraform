# VPC Module
module "vpc" {
  source = "./module/vpc"
  region= var.region
  az1= var.az1
  az2= var.az2
  az3= var.az3
  vpc_cidr_block= var.vpc_cidr
  public_sub_cidr= var.public_cidr
  public_sub2_cidr= var.public2_cidr
  private_sub_cidr = var.private_cidr
  project = var.project
}


# asg Module
module "asg" {
  source = "./module/asg"
  region = var.region
  ami_id = var.ami_id
  instance_type = var.instance_type
  name1 = var.name1 # launch-temp-1
  name2= var.name2 # launch-temp-2
  project = var.project
}

# ALB module
module "alb" {
  source = "./module/alb"
  region = var.region
  project = var.project
}

#RDS module
module "rds" {
  source = "./module/rds"
  region = var.region
  GB = var.GB
  db_name = var.db_name
  engine_name = var.engine_name
  engine_version = var.engine_version
  instance_class = var.instance_class
  username = var.username
  password = var.password
  parameter_group_name = var.parameter_group_name
}

# IAM user
module "iam"{
  source = "./module/iam"
  region = var.region
  username1 = var.user1_iam
  policy_name = var.iam_policy_name
  # simple
  username2 = var.user2_iam
  policy_arn = var.iam_policy_arn
}

