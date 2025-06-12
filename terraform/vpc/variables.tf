variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDR's"
  type = list(string)
}

variable "availability_zone" {
  description = "List of availabiity zone for public subnets"
  type = list(string)
}

variable "project" {
  description = "Name prefix for resources"
  type = string
}