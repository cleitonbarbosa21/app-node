#### VPC ####

resource "aws_vpc" "this" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = var.vpc.name }
}

##### Subnets públicos #####

resource "aws_subnet" "public" {
  count = length(var.vpc.public_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpc.public_subnets[count.index].cidr_block
  availability_zone       = var.vpc.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.vpc.public_subnets[count.index].map_public_ip_on_launch

  tags = { Name = var.vpc.public_subnets[count.index].name }
}

##### Subnets privados #####

resource "aws_subnet" "private" {
  count = length(var.vpc.private_subnets)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpc.private_subnets[count.index].cidr_block
  availability_zone       = var.vpc.private_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.vpc.private_subnets[count.index].map_public_ip_on_launch

  tags = { Name = var.vpc.private_subnets[count.index].name }
}

##### Internet Gateway e Route Tables das subnets públicas ####

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.vpc.internet_gateway_name
  }
}


resource "aws_route_table" "public_access" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = var.vpc.public_route_table_name }
}

resource "aws_route_table_association" "public_access" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_access.id
}


##### NAT Gateway e Route Tables das subnets privadas ####

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = { Name = var.vpc.internet_gateway_name }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.public, 0).id

  tags = { Name = var.vpc.nat_gateway_name }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "rt_private_access" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = var.vpc.private_route_table_name }
}

resource "aws_route_table_association" "private_access" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.rt_private_access.id
}


