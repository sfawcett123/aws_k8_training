resource "aws_security_group" "bastion" {
  name        = "bastion_security"
  description = "Allow Traffic to the Bastion"
  vpc_id      = var.vpc_id

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

  tags = merge( var.tags , { "Module" = "Bastion" })
}


data "aws_ami" "server" {
  most_recent = true
  filter {
    name   = "name"
    values = var.ami_name
  }
  filter {
    name   = "virtualization-type"
    values = var.ami_virtualization_type
  }
  owners = var.ami_owners
}


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.server.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
# user_data                   = "${file("install_apache.sh")}"

  tags = merge( var.tags , { "Module" = "Bastion" , "Architecture" = data.aws_ami.server.architecture , "AMI_Name" = data.aws_ami.server.name })
}
