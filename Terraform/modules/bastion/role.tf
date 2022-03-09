resource "aws_iam_role" "ec2_role" {
  name        = "sf-bastion-ec2-access"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }, ]
  })
  tags = merge( var.tags , { "Module" = "Bastion" })
}

resource "aws_iam_instance_profile" "bastion_profile" {
   name = "BastionProfile"
   role = aws_iam_role.ec2_role.name
}


