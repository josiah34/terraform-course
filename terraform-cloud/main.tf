terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  cloud {
    organization = "master-terraform-jg"
    workspaces {
      name = "terraform-cloud"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.SECRET_KEY
}



resource "aws_instance" "server" {
    ami = "ami-04cb4ca688797756f"
    instance_type = "t2.micro"
    tags = {
        "Name" = "my-server"
    }
}

