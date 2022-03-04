---
title: Connectivity
nav_order: 50
parent: AWS Bastion
layout: page
---

# Connect to the Bastion Server
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
I am sure you have tried but the SSH to the bastion IP address still does not work. Whats wrong? well we find there are two things wrong:

1. No route from Internet to Bastion
2. Security Group permissions 

## Fix Problems

### Add a Route
What we need is an Internet Gateway, and a route from that to the PUBLIC subnet, So the first step is to create a `routes.tf` file with the following route table entry.

```
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}
```

associate this route with the public subnet

```
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

then we need to create an internet gateway

```
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}
```
 and now we can create a route for all traffic between the internet gateway and the subnet
 
``` 
 resource "aws_route" "route_1" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
```

### Create a Security Group

we need to allow SSH traffic from the internet into the Bastion server, to do this we must edit the `bastion.tf` file. 

Add the following security group; this will allow port 22 (SSH ) from anywhere access. 

```
resource "aws_security_group" "bastion" {
  name        = "bastion_security"
  description = "Allow Traffic to the Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
```

This security group needs to be added to the bastion server, so we must change the aws_instance to add the vpc_security_group_id.

```
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
}

```

You are ready to apply these changes, and now when you SSH you will get a connection, but your Key pair isn't set up, so you cannot connect.
