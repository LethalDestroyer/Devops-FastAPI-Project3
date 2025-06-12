variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
}

variable "docker_image" {
  description = "Docker image to run"
  type        = string
}

variable "project" {
  description = "Project name prefix"
  type        = string
}
