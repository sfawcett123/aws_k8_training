data aws_subnet "selected" {
    id = var.subnet_id
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
