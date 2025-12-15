provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "my_sg" {
  
}


/* Import

    cmd-syntax = " terraform import <resource type>.<resource block name> <resource_id from console>"

    cmd - " terraform import aws_security_group.my_sg sg_0a162c3d4e5f6g7h "

        - this cmd is used to import/add resource which is manually created from aws console to terraform 
            so, that from next time resource can be use from terraform.
        - for this create a empty resource block of that perticular resource which will be imported
            and then run import cmd 
        - it will update the .tfstate file and confis. will be added but resource block will be still
            empty, for that we have to manually add The configs of that resource form .tfstate file or
            aws console


*/