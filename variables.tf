variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "SSH key name"
  type        = string
}

variable "availability_zone" {
  description = "La zona de disponibilidad para las instancias"
  type        = string
  default     = "sa-east-1a"  # Define una zona por defecto
}
