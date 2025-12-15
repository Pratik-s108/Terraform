provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_instance"{
    ami = var.ami_id
    instance_type = var.instance_type

    tags = {
      name = var.instance_name
      env = var.env
    }
}
