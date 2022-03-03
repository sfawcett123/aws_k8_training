#
# Create a security group in the VPC to allow SSH trafic to the Bastion
#

resource "aws_security_group" "bastion" {
  name        = "bastion_ssh"
  description = "Allow SSH to Bastion"
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

  tags = merge(var.tags, { "ROLE" = "BASTION" })
}

#
# Find the AMI of something Unbunto
#

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

#
# We should have a Private an Public key on our local system which we
# can use to connect to the Bastion server
#

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = file("./public_key.pem")
  tags       = merge(var.tags, { "Name" = "Steves Bastion KeyPair" })
}

#
# Create our Bastion server, using the Ubuntu AMI in the 
# subnet and associate the security group
#

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.generated_key.key_name

  tags = merge(var.tags, { "Name" = "Steves Bastion Server" })
}

output "bastion_public_ip" {
  value = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.bastion.public_ip}"
}
