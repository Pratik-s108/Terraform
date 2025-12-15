provider "aws"{
    region = var.region
}

resource "aws_instance" "my_block"{
    ami = var.ami_id
    instance_type = var.instance_type
    tags ={
        Name = "${terraform.workspace}-my-instance"  # name based tag (if you run in dev env the name tag will be "dev-my-instance")
        env = "${terraform.workspace}-instance"  # env based tag (if you run in dev env the env tag will be "dev-instance")
    }
}

/*
 terraform workspace creates a isolated env. (dev, test, provider) which will provide one terraform.tfstate file in 
 every environment.
 the main.tf file will be same for all env but when we apply(instance_type = t3.micro) in a perticular env (dev) 
 the changes will be only in dev env terraform.tfstate file, if we switch to "test" env and change the 
 main.tf(instance_type = m7i-flex.large) and apply the changes will be only on test env. as same as for 
 prod env if we change(instance_type = t3.small) and apply main.tf

  dev - terraform.tfstate = "t3.micro"
  test - terraform.tfstate = "m7i-flex.large"
  prod - terraform.tfstate = "t3.small"

   terraform.tfstate.d is the file which stores workspace configs, if it is deleted the ws will be deleted
 }

*/