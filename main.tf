# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = "main-vpc"
    }
  )
}

# Subnets
resource "aws_subnet" "public" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "public-subnet-${count.index + 1}"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "main-igw"
    }
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "public-route-table"
    }
  )
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "web-security-group"
    }
  )
}

# EC2 Instances
resource "aws_instance" "web" {
  count                       = length(var.subnet_cidrs)
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[count.index].id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  availability_zone           = var.availability_zone

  tags = merge(
    local.common_tags,
    {
      Name = "${local.instance_name}-${count.index + 1}"
    }
  )
}
