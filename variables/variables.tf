variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "The CIDR block for the VPC. Default value is a /24 netmask."
  type        = string
}

variable "web_subnet_cidr_block" {
  default     = "10.0.10.0/24"
  description = "value for web subnet cidr block"
  type        = string
}


variable "web_port" {
  description = "The port the web server will use for HTTP requests."
  default     = 80
  type        = number
}


variable "aws_region" {
  description = "The AWS region to launch in."
  default     = "us-east-1"
  type        = string
}

variable "enable_dns" {
  description = "DNS Support for the VPC"
  type        = bool
  default     = true
}

variable "main_vpc_name" {}

variable "my_public_ip" {}

# Collection : List, map, set 
# Groups values of the same type 

#LIST
variable "azs" {
  description = "AZs in the region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}



#MAP

variable "amis" {
  type = map(string)
  default = {
    us-east-1 = "ami-041feb57c611358bd"
    us-east-2 = "ami-080c09858e04800a1"
  }
}


# Structural: Object, tuple
# Groups values of different types


# Tuple 
variable "my_instance" {
  type = tuple([string, number, bool])
  default = [
    "t2.micro",
    1,
    true
  ]
}

# Object

variable "egress_dsg" {
  type = object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_blocks = list(string)
  })
  default = {
    from_port   = 0,
    to_port = 0,
    protocol = "-1",
    cidr_blocks = ["100.0.0.0/16", "200.0.0.0/16" ]

  }
}

