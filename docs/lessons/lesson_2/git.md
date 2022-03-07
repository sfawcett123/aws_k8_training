---
title: GIT Souce control
nav_order: 40
parent: Drying Terraform Out
layout: page
---

# GIT Souce control
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
We all know about GIT but what we now can do is source our terraform modules from it. 

## Change Source

[Module Sources](https://www.terraform.io/language/modules/sources#module-sources) 

We have been using the repository [https://github.com/sfawcett123/aws_k8_training](https://github.com/sfawcett123/aws_k8_training) to store our code, and we know our module is kept in the sub directory /Terraform/L2/network. 

Therefore we can change the source of our module in our main Terraform to 

``"git::https://github.com/sfawcett123/aws_k8_training.git//Terraform/L2/network"`` and if we wanted a specific version 

```
module "network_stuff" {
  source             = "git::https://github.com/sfawcett123/aws_k8_training.git//Terraform/L2/network?ref=main"
  common_tags        = var.common_tags
  vpc_cidr_block     = var.vpc_cidr_block
  private_cidr_block = var.private_cidr_block
  public_cidr_block  = var.public_cidr_block
}
```
