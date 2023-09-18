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



resource "aws_vpc" "main" {
  cidr_block =  var.vpc_cidr_block

  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }

}


resource "aws_subnet" "web" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnet_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Web subnet"
  }

}

# resource "aws_vpc" "myvpc" {
#   cidr_block = "192.168.0.0/16"

#   tags = {
#     "Name" = "my vpc"
#   }

# }