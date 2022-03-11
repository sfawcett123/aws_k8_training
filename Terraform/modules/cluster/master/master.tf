resource "aws_security_group" "master" {
  name        = "master_node_security"
  description = "Allow Traffic to the Kubernetes Master Nodes"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { "Module" = "Cluster", "Cluster" = "Master" })
}

resource "aws_instance" "master" {
  ami                    = data.aws_ami.server.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [aws_security_group.master.id]
  key_name               = var.key_pair_name
  # user_data                   = "${file("install_apache.sh")}"

  tags = merge(var.tags, { "Module" = "Cluster", "Cluster" = "masters", "Architecture" = data.aws_ami.server.architecture, "AMI_Name" = data.aws_ami.server.name })
}
