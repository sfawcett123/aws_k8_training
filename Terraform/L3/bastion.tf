module "network_stuff" {
  source             = "git::https://github.com/sfawcett123/aws_k8_training.git//Terraform/L2/network?ref=main"
  common_tags        = var.common_tags
  vpc_cidr_block     = var.vpc_cidr_block
  private_cidr_block = var.private_cidr_block
  public_cidr_block  = var.public_cidr_block
}


# Find the AMI of something Unbunto
#
resource "aws_security_group" "bastion" {
  name        = "bastion_security"
  description = "Allow Traffic to the Bastion"
  vpc_id      = module.network_stuff.vpc_id

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

  tags = var.common_tags
}

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

resource "aws_key_pair" "generated_key" {
  key_name   = "SSH-Key-2"
  public_key = file("./public_key.pem")

  tags = var.common_tags
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.network_stuff.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name

  user_data                   = file("install.sh")

  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name 

  tags = var.common_tags
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
