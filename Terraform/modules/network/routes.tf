resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags , { "Module" = "Network" , "Subnet" = "Public" })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags , { "Module" = "Network" })
}

resource "aws_route" "route_1" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge( var.tags , { "Module" = "Network" , "Subnet" = "Private" })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id

}

resource "aws_eip" "natgw" {
  vpc = true

  tags = merge( var.tags , { "Module" = "Network" })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.main]

  tags = merge( var.tags , { "Module" = "Network" })
}

resource "aws_route" "route_2" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id

}
