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



resource "aws_instance" "testing-server" {
  ami           = "ami-041feb57c611358bd"
  instance_type = "t2.micro"
  key_name      = "prod_ssh_key"
  count  = var.istest == true ? 1 : 0        
  tags = {
    Name = "testing_server"
  }

}



resource "aws_instance" "prod-server" {
  ami           = "ami-041feb57c611358bd"
  instance_type = "t2.large"
  key_name      = "prod_ssh_key"
  tags = {
    Name = "prod_server"
  }
  count = var.istest == false ? 1 : 0

}



