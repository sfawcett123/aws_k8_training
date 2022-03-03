#
# Create a VPC
#

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { "Name" = "Steves VPC" })
}

#
# Create a Route Table
#

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "Public Route" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { "Name" = "Private Route" })
}

#
# Subnets
#

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  availability_zone =  "eu-west-1a"

  tags = merge(var.tags, { "Name" = "Public Subnet" })
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone =  "eu-west-1a"

  tags = merge(var.tags, { "Name" = "Private Subnet" })
}

output "public_cidr_block" {
  value = aws_subnet.public.cidr_block
}

output "private_cidr_block" {
  value = aws_subnet.private.cidr_block
}

#
# Associate the route table to the Subnet 
#

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

#
# Create an internet gateway
#

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { "Name" = "Steves IGW" })
}


#
# Create route for the internet gateway
#

resource "aws_route" "route_1" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

  depends_on = [aws_route_table.public]
}

#
# Create NAT gateway
#

resource "aws_eip" "natgw" {
  vpc = true

  tags = merge(var.tags, { "Name" = "Steves NGW IP" })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public.id

  tags = merge(var.tags, { "Name" = "Steves NAT" })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "route_2" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id

  depends_on = [aws_route_table.private]
}
