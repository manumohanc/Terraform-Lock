variable "region" {

  default     = "ap-south-1"
  description = "Default region the project is created on"

}

variable "access_key" {

  default     = 
  description = "Enter the access key"

}

variable "secret_key" {

  default     = 
  description = "Secret key of the terraform IAM user"

}

variable "project" {

  default     = "Zomato"
  description = "Name of the project"

}

variable "instance_ami" {

  default = "ami-0cca134ec43cf708f"

}

variable "instance_type" {

  default = "t2.micro"

}

variable "environment" {

  default = "dev"

}

variable "vpc_cidr" {

  default = "172.16.0.0/16"

}
