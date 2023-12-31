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
  region = var.aws_region
}


# Create VPC

resource "aws_vpc" "main" {
  cidr_block         = var.vpc_cidr_block
  enable_dns_support = var.enable_dns

  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }

}

# Create Subnet 
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.web_subnet_cidr_block
  availability_zone = var.azs[2]
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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
  }

  ingress {
    from_port   = var.web_port
    to_port     = var.web_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress_dsg["from_port"]
    to_port     = var.egress_dsg["to_port"]
    protocol    = var.egress_dsg["protocol"]
    cidr_blocks = var.egress_dsg["cidr_blocks"]
  }

  tags = {
    "Name" = "Default Security Group for ${var.main_vpc_name}"
  }
}

resource "aws_instance" "server" {
  ami           = var.amis[var.aws_region]
  instance_type = var.my_instance[0]
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = var.my_instance[2]
  key_name                    = "prod_ssh_key"
  tags = {
    "Name" = "my-server"
  }
}



# resource "aws_instance" "server" {
#   ami                         = "ami-04cb4ca688797756f"
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.web.id
#   vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
#   associate_public_ip_address = true
#   key_name                    = "prod_ssh_key"
#   tags = {
#     "Name" = "my-server"
#   }
# }


# resource "aws_vpc" "myvpc" {
#   cidr_block = "192.168.0.0/16"

#   tags = {
#     "Name" = "my vpc"
#   }

# }