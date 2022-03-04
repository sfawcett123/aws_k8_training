---
title: Network Address Translator
nav_order: 70
parent: AWS Bastion
layout: page
---

# Network Address Translator
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
You will be able to SSH onto your new bastion server, and no doubt you want to install something. but it cannot reach the internet, `sudo apt update` just hangs.

The problem is you have no route from your server to the internet, you need an Network Address Translator Gateway (NAT_Gateway )

So a NAT Gateway routes outbound traffic from your Private Subnet through to the internet and for that to work we need:

1. Private Subnet
2. Private Route Table
3. Network Address Gateway
4. Egress Permissions on the Bastion

### Create a Private Subnet
Edit your `subnets.tf `file and add a new resource.

```
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}
```

notice how it looks identical to the public subnet, other than the ip address range.

### Create a Private Route table
In your `routes.tf` file create a subnet and associate it with the private subnet, just like you did with the public route.

```
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
```

### Create a NAT gateway
Also in your `routes.tf` file you need to create an Elastic IP address, and also create a NAT gateway. It is important to ensure the NAT Gateway is created after the internet gateway, so use the depends_on metatag. Note that the NAT_Gateway is created in the PUBLIC subnet.

```
resource "aws_eip" "natgw" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.main]
}
```

The NAT Gateway can take a few minutes to deploy, so be patient.

### Create a route to your NAT gateway

Now you need a Route from your Private Subnet to your NAT Gateway, so add the following to your `routes.tf`

```
resource "aws_route" "route_2" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}
```

### Create EGRESS Security Rule.

Terraform manages all the Security groups. By default AWS permits all outgoing traffic, but terraform will delete those settings. so we need to add an egress rule to our security group, by editing the `bastion.tf` file and changing the security_group too.

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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
```

Now once everything is applied the command `sudo apt-get update` will work and your bastion server has access to the internet.

