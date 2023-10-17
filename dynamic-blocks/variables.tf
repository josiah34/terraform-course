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

variable "main_vpc_name" {}


variable "ingress_ports" {
  description = "The ingress ports to allow through the security group"
  type        = list(number)
  default     = [22, 80, 443, 993, 8080]
}