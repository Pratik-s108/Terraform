# count

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  count = 3
  tags = {
    name = "inst-1"
  }
}