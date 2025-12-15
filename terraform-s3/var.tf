variable "bucket_name" {
  default = "s3-bucket-9096"
}
variable "tfstate_file" {
  default = "terraform.tfstate"
}
variable "region" {
  default = "ap-south-1"
}
variable "ami_id" {
  default = "ami-02b8269d5e85954ef"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "tag_name" {
  default = "My-instance"
}