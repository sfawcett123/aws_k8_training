---
title: Public Subnet
nav_order: 30
parent: AWS Bastion
layout: page
---

# Create a Public Subnet
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
Subnets are networks within networks, so for oursake we have a large Virtual Private cloud, but we want to compartmentise resources, keeping them seperate. Imagine the VPC as a house and the subnets are different rooms within that house.

You will hear the terms PUBLIC and PRIVATE subnets, there are no differences on how we create them, and technically these are just names, we could have three subnets called Tom, Dick and Harry if we liked, but it does make understanding what they are used for a little complicated.

The PUBLIC subnet is going to be set up as your gateway to the internet, a way for network traffic to enter and exit your application. 

A subnet basically consists of a range of IP addresses in a CIDR block, which is a subset of the VPCs CIDR block. so in this case we will use 10.0.0.0/24 which are IP addresses from10.0.0.0 to 10.0.0.255

## Create Public Subnet

### Subnet

so if we create a file called subnets.tf, plural because later we will add another subnet. but for the moment we will just create the public subnet.

```
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
}
```

we can now run `terraform apply` 
