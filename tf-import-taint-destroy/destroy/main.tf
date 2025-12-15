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

resource "aws_instance" "my_instance2" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t3.small"
  tags = {
    Name = "my_instance2"
  }
}

/* Destroy single/perticular resource

    cmd-syntax = " terraform destroy --target=<resource type>.<resource block name> "

    cmd - " terraform destroy --target=aws_instance.my_instance1"

     - this cmd will destroy a perticular block rather than destroying all in once.


*/