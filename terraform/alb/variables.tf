variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to launch resources in"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port application is listening on (e.g., 8000)"
  type        = number
  default     = 8000
}

variable "instance_id" {
  description = "ID of EC2 instance to attach to Target Group"
  type        = string
}
