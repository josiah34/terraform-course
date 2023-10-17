variable "instance_type" {
    type = string 
    description = "The type of EC2 instance to launch"
    default = "t2.micro"
}


variable "ami_id" {
    description = "The AMI to use for the EC2 instance"
    type = string 
    default = "ami-04cb4ca688797756f"
}
  

variable "servers" {
    description = "The number of EC2 instances to launch"
    type = number
    default = 1
}