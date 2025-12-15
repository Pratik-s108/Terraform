/* Terraform block:
                  - define a perticular terraform version
                  - use to store tf.tfstate file remotly (in s3) for backup purpose
*/
terraform {
  backend "s3" {
    bucket = var.bucket_name
    key    = var.tfstate_file
    region = var.region
    
  }
}

provider "aws" {
    region = var.region
}

resource "aws_instance" "my_instacne" {
   ami = var.ami_id
   instance_type = var.instance_type
    tags = {
        Name = var.tag_name
        env = "prod"
    }
}

