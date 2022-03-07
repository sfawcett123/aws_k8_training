resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  
  cidr_block = var.public_cidr_block

  tags = var.common_tags
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id

  cidr_block = var.private_cidr_block

  tags = var.common_tags
}
