provider "aws"{
    region = "ap-south-1"
}


resource "aws_instance" "web" {
  ami = "ami-02b8269d5e85954ef"
  instance_type = "t3.micro"
  tags = {
    Name = "instance"
  }
  key_name = "key"

  # provisioner file (copy file from local to remote)
  provisioner "file" {
    source = "./file.txt"
    destination = "/home/ubuntu/file.txt"
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("C:\\Users\\ASUS\\Downloads\\key.pem")
    host        = self.public_ip
  }

  #provisioner local-exec for single cmd (print/create inside resource(instance) when it is created)
  provisioner "local-exec" {
    command = "touch ec2.txt"
  }

  #Remote-exec for multiple cmds [But instead of this we use "user-data" for running cmds inside istance]
  provisioner "remote-exec" {
    inline =[
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo echo '<h1> This is Demo </h1>' >> /var/www/html/index.html"
    ]
  }
}