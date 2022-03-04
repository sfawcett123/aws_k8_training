---
title: Create Bastion Server
nav_order: 40
parent: AWS Bastion
layout: page
---

# Create Bastion Server
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
Taking the analogy that the VPC is a house and the public subnet is our hallway, then we need to have some sort of platform where we can gain enterance to work inside. This could be a windows server or a Linux server, it really depends on you.

## Create
The first step is to create a file `bastion.tf`, seems a good name. You could call the file anything you liked. however, in the future you may want to come back and edit these files, and it would be easier to identify what they do if you give them logical names.

### AMI
The first step in our `bastion.tf` file is to find an Amazon Machine Image (AMI) which suits our needs. There is a long list of them and it gets longer every day. It is also possible for you to create your own. but in this case I want to use an Unbuntu image.

```
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
```

Now we have the AMI we want, we can add the creation of the server in the subnet we created earlier. The only other settings we need are:

### Instance Type
This is the size of the server is defined by an [instance type](https://aws.amazon.com/ec2/instance-types/). The more powerful the instance type the more money you will spend, so choose depending on your needs. The bastion is going to be used to SSH in and install software on the cluster, so does not need to be powerful

### Associate Public IP Address
You will want to access this server from your workstation, so we will need a public facing IP address.

### Server 

Add the following to your `bastion.tf `file

```
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
}
```

### Deploy

Now apply this, after a few seconds your server will be created. but you have no way of knowing how to connect to it.

### Connect

So if we add an output to the `bastion.tf` file which will display the public IP address, you can then run apply again, and you will see your servers IP address.

```
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
```
