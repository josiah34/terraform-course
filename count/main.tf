terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}



# resource "aws_instance" "server" {
#   ami           = "ami-041feb57c611358bd"
#   instance_type = "t2.micro"
#   count = 2
#   tags = {
#     "Name" = "my-server"
#   }
# }


variable "users" {
    type = list(string)
    default = ["joey",  "smoe"]
}

# resource "aws_iam_user" "test" {
#     name = "test-user${count.index}"
#     path = "/system/"
#     count = 5
# }


# resource "aws_iam_user" "test" {
#     name = "${element(var.users, count.index)}"
#     path = "/system/"
#     count = "${length(var.users)}"
# }

resource "aws_iam_user" "test" {
    for_each = toset(var.users)
    name = each.key 
}



