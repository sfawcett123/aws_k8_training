---
title: Connect to AWS
nav_order: 30
parent: Improve Bastion
layout: page
---

# Connect to AWS
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
when we run `aws ec2 --region eu-west-1 describe-instances` we see a warning 

```
Unable to locate credentials. You can configure credentials by running "aws configure".
```

To solve this we can create an AWS Role, and attach that to the instance, allowing any user of that instance access to AWS.

### Create a AWS Role
we need to create a `role.tf` file and create the following resources.

```
resource "aws_iam_role" "ec2_role" {
  name        = "bastion-ec2-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }, ]
  })

  managed_policy_arns = [ "arn:aws:iam::aws:policy/AmazonEC2FullAccess" ]
}

resource "aws_iam_instance_profile" "bastion_profile" {
   name = "BastionProfile"
   role = aws_iam_role.ec2_role.name
}
```

This will create an IAM role, which will grant access to its user EC2 with full access. We can then create a profile using this role. before you carry out an apply, I suggest you run `terraform init --upgrade`

### Attach role to instance
Adding the line `iam_instance_profile = aws_iam_instance_profile.bastion_profile.name` to the resource, will attach the profile you created to the instance and you can then apply this change.

```
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
```

### Redeploy
We can now redeploy the script and when we ssh into the server,  Try `aws ec2 --region eu-west-1 describe-instances` and you will should now get a list of all the instances you can manage.
