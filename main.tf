provider "aws" {
    region = var.region
  
}

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.project-name}-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project-name}-igw"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "PublicA" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.PublicA_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "pubic_AZA"
  }
}

resource "aws_subnet" "PublicB" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.PublicB_cidr
  availability_zone = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "pubic_AZB"
  }
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

 
  tags = {
    Name = "Public_route"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      =aws_subnet.PublicA.id
  route_table_id = aws_route_table.Public.id
}

