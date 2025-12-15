# FOR-each loop

provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "my_instance" {
  for_each = toset(var.ami_ids)
  ami = each.value
  instance_type = "t3.micro"
  tags = {
    name = "inst-${each.key}"
  }
}

variable "ami_ids" {
  default = ["ami-01ca13db604661046","ami-02b8269d5e85954ef","ami-00ca570c1b6d79f36"]
}

#For loop (output)
output "public_id" {
  value = {for server, instance in aws_instance.my_instance: server=> instance.public_ip}
}