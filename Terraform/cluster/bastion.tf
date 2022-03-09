module "network" {
  #  source             = "git::https://github.com/sfawcett123/aws_k8_training.git//Terraform/L2/network?ref=main"
  source             = "/Users/stevenfawcett/TRAIN/Terraform/modules/network"
  vpc_cidr_block     = var.vpc_cidr_block
  private_cidr_block = var.private_cidr_block
  public_cidr_block  = var.public_cidr_block

  tags = var.common_tags
}

resource "aws_key_pair" "generated_key" {
  key_name   = "SSH-Key"
  public_key = file("./public_key.pem")

  tags = var.common_tags
}

module "bastion" {
  #  source             = "git::https://github.com/sfawcett123/aws_k8_training.git//Terraform/L2/network?ref=main"
  source           = "/Users/stevenfawcett/TRAIN/Terraform/modules/bastion"
  subnet_id        = module.network.public_subnet_id
  key_pair_name    = aws_key_pair.generated_key.key_name

  tags = var.common_tags
}

module "cluster_master" {
  #  source             = "git::https://github.com/sfawcett123/aws_k8_training.git//Terraform/L2/network?ref=main"
  source           = "/Users/stevenfawcett/TRAIN/Terraform/modules/cluster/master"
  subnet_id        = module.network.private_subnet_id
  key_pair_name    = aws_key_pair.generated_key.key_name

  tags = var.common_tags
}

output "bastion_public_ip" {
  value = "ssh -i ${aws_key_pair.generated_key.key_name}.pem ubuntu@${module.bastion.public_ip}"
}
