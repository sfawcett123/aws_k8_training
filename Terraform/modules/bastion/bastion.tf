resource "aws_security_group" "bastion" {
  name        = "bastion_security"
  description = "Allow Traffic to the Bastion"
  vpc_id      = data.aws_subnet.selected.vpc_id

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

  tags = merge(var.tags, { "Module" = "Bastion" })
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.server.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  user_data_base64            = data.template_cloudinit_config.config.rendered
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  tags = merge(var.tags, { "Module" = "Bastion", "Architecture" = data.aws_ami.server.architecture, "AMI_Name" = data.aws_ami.server.name })
}
