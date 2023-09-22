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
  region = "us-east-2"
}


# Create VPC

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }

}

# Create Subnet 
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_cidr_block
  availability_zone = "us-east-2a"
  tags = {
    "Name" = "Web subnet"
  }

}

# Create an Internet Gateway

resource "aws_internet_gateway" "web_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.main_vpc_name} Gateway"
  }
}

# Create a Route Table

resource "aws_default_route_table" "main_vpc_default_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_gateway.id
  }
  tags = {
    "Name" = "Main VPC Default Route Table"
  }
}

# Configure the deault security group for the VPC

resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Default Security Group for ${var.main_vpc_name}"
  }
}

# By using the data source, we can get the latest Amazon Linux 2 AMI ID regardless of region or architecture.

# If this was hard coded we would have to update the AMI ID every time we wanted to use a different region or architecture.

data "aws_ami" "latest_amazon_linux2" {
    owners = ["amazon"]
    most_recent = true 
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-*-x86_64-gp2"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }

}

resource "aws_instance" "server" {
    ami = data.aws_ami.latest_amazon_linux2.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.web.id
    vpc_security_group_ids = [aws_default_security_group.default_sec_group.id]
    associate_public_ip_address = true
    key_name = "us-2-key"
    tags = {
        "Name" = "my-server"
    }
}



# resource "aws_vpc" "myvpc" {
#   cidr_block = "192.168.0.0/16"

#   tags = {
#     "Name" = "my vpc"
#   }

# }