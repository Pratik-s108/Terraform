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


/* refresh 

    cmd = " terraform apply --refresh-only "

        - this cmd is used to update the .tfstate file when a user made changes in a resource 
            (which is created using terraform) from aws console 

        for.ex :
            A instance is created using terraform and another user changes its instance_type(t3.micro to t3.small) 
                from aws_console but in terraform .tfstate file it will not update for this we will use refresh-only
                cmd to refresh the updates or to update the .tfstate file.
            But it will only update .tfstate file not resource block for that we have to do manual changes.

*/