terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
  #configuração backend para guardar o estado do recurso VPC
  # bucket nome do bucket onde será armanenado
  # key é a chave/caminho onde será armazenado no bucket

  backend "s3" {
    bucket = "bucket-fiap56-to-remote-state"
    key    = "aws-vpc-network-fiap56/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      owner      = var.owner
      managed-by = var.managedby
    }
  }
}

resource "aws_vpc" "vpc_fasteats" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-fasteats"
  }
}

resource "aws_subnet" "subnet_fasteats_privada" {
  vpc_id     = aws_vpc.vpc_fasteats.id
  cidr_block = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false  # Private subnet
  tags = {
    Name = "subnet-fasteats-privada"
  }
}

# Subnets (Public)
resource "aws_subnet" "subnet_fasteats_publica" {
  vpc_id                  = aws_vpc.vpc_fasteats.id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-fasteats-publica"
  }
}

resource "aws_internet_gateway" "internet_gateway_fasteats" {
  vpc_id = aws_vpc.vpc_fasteats.id

  tags = {
    Name = "internet-gateway-fasteats"
  }
}

resource "aws_route_table" "route_table_fasteats" {
  vpc_id = aws_vpc.vpc_fasteats.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_fasteats.id
  }

  tags = {
    Name = "route-table-fasteats"
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.subnet_fasteats_publica.id
  route_table_id = aws_route_table.route_table_fasteats.id
}

resource "aws_security_group" "security_group_fasteats" {
  name        = "security-group-fasteats"
  description = "Permitir acesso na porta 22 ..."
  vpc_id      = aws_vpc.vpc_fasteats.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8082
    to_port   = 8082
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "security_group_fasteats"
  }
}