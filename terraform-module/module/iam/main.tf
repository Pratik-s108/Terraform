provider "aws" {
  region = var.region
}

# Username and user is placed under the IAM path /system/ 
resource "aws_iam_user" "iam" {
  name = var.username1
  path = "/system/"
}

/* Access key and secret key - (the secret key will displayed once while cration time 
                                or stored in .tfstate file or use output block to display 
                                or run " terraform output iam_secret_access_key " ) */
resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iam.name
}

# Using existing data from policy docs. for iam policy/permissions
data "aws_iam_policy_document" "iam_policy" {   #administrator access
  statement {
    effect = "Allow"
    actions = [ "*" ]
    resources = [ "*" ]
  }
}

# Attaching policy/permissions to user
resource "aws_iam_user_policy" "user_policy" {
  name   = var.policy_name               #Policyname
  user   = aws_iam_user.iam.name
  policy = data.aws_iam_policy_document.iam_policy.json
}

# output access-key for user
output "access_key_id" {
  value = aws_iam_access_key.iam_access_key.id
}
#output secret-key from user
output "secret_key_id" {
  value = aws_iam_access_key.iam_access_key.secret
  sensitive = true
}
# or can use " terraform output secret_key_id" show once




# Creating user and attaching permisson/policy without creating policy 

# Creating user 
resource "aws_iam_user" "iam1" {
  name = var.username2
}

# attaching policy to user
resource "aws_iam_user_policy_attachment" "iam_attach" {
  user       = aws_iam_user.iam1.name
  policy_arn = var.policy_arn    # AdministratorAccess arn from aws console
}

# creating access-key and secret-key
resource "aws_iam_access_key" "iam_access_key1" {
  user = aws_iam_user.iam1.name
}
/*
    ( the secret key will displayed once while creation time 
    OR stored in .tfstate file 
    OR use output block to display 
    OR run " terraform output iam_secret_access_key " )
*/

# output access-key for user1
output "access_key_id1" {
  value = aws_iam_access_key.iam_access_key1.id
}
# output secret-key for user1
output "secret_key_id1" {
  value = aws_iam_access_key.iam_access_key.secret
  sensitive = true
}
# or can use " terraform output secret_key_id1" show once
