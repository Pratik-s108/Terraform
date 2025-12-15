provider "aws" {
    region = var.region
}

resource "aws_db_instance" "default" {
  allocated_storage    = var.GB
  db_name              = var.db_name
  engine               = var.engine_name
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = true
}