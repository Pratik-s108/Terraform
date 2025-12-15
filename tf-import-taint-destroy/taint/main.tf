provider "aws"{
    region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  tags = {
    Name = "my_instance"
  }
}

/*  Taint (corrupt)

    cmd syntax - " terraform taint <resource type>.<resource block name> " 

    cmd - " terraform taint aws_instance.my_instance "  - this will mark as a taint(corrupt) then use apply cmd for changes/recreate
    cmd - " terraform apply --auto-approve " 

      - this cmd is used when a instance has issue ( like 0/2, 1/2 or manually changes from aws console) 
        while launching a resource (instance) it will recreate the resource and update in terraform.tfstate file,
        but will not update in resource block for that do it manually (if changes made manually form aws console)
      - this cmd is deprecated but still some uses

    OR use 

    cmd syntax - " terraform apply --replace="<resource type>.<resource block name>" "

    cmd - " terraform apply --replace="aws_instance.my_instance" "

        this cmd works same as taint can say alternate cmd


 for Ex: 
        create a resource instance from terraform check the .tfstate file 
        and then open aws console change ami/instance_type of that same instance 
        then apply taint cmd then check .tfstate file the updates will be displayed.

*/