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
  availability_zone = "us-east-1a"
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
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   # cidr_blocks = [var.my_public_ip]
  # }


  # This will dynamically create the ingress block for the security group
  # Loops through the list of ports in the variable "ingress_ports" and creates a block for each port
  # The "for_each" meta-argument is used to create multiple instances of a resource or module
  # The "content" argument is used to define the body of the dynamic block


  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Default Security Group for ${var.main_vpc_name}"
  }
}

resource "aws_instance" "server" {
  ami                         = "ami-04cb4ca688797756f"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
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