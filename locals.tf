# locals.tf
locals {
  instance_name = "web-server"
  environment   = "development"
  common_tags = {
    Project     = "desafio-terraform"
    Environment = local.environment
  }
}

data "aws_availability_zones" "available" {}