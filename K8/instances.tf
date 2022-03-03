
resource "aws_security_group" "kubernetes" {
  name        = "kubernetes"
  description = "Allow access to kubernetes"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, { "Name" = "k8 security group" })
}

resource "aws_key_pair" "instance_key" {
  key_name   = var.key_name
  public_key = file("./public_key.pem")
  tags       = merge(var.tags, { "Name" = "Steves Instance KeyPair" })
}

resource "aws_instance" "kubernetes" {
  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.kubernetes.id]
  availability_zone      = "eu-west-1a"
  private_ip             = cidrhost(aws_subnet.private.cidr_block, 10 + count.index)

  key_name = aws_key_pair.instance.key_name

  tags = merge(var.tags, { "Name" = "Steves kubernetes Server" })
}

