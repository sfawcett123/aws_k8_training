---
title: Modules
nav_order: 30
parent: Drying Terraform Out
layout: page
---

# Modules
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction

Once you have built a  group of components, you may want to do the same thing again and again. It makes no sence to re-write all this each time, so we can build modules. which can be re-used and all our good practices automatically rolled out to other parts of the system.

## Modules

Terraform modules are greate for this and can be stored in source control allowing easy re-use. but first we will create our module locally.

## Network

We have created a little VPC and the infrastructure to allow ingress and egress to the internet, which maybe of use later on. so we are going to take the network side of our project and convert it into a simple module.

### Step 1 - Create the module
First we will create a new directory for our module, and move the components we want to be part of the module into that directory.
 
```
mkdir network
mv subnets.tf vpc.tf routes.tf network/
```

### Step 2 - Call the module 
From our main terraform we need to call the module. We can do that in the `bastion.tf` by adding the block.

```
module "network_stuff" {
  source                            = "./network"
}
```

it is import to carry out a `terraform init --upgrade` whenever you change a module during development.

### Step 3 - Fix missing input variables.
When you run the terraform plan you will notice a few failures, this is caused by the variables required in the networking components not being available. We need to pass them through to the module.


we are missing some variables, so we need to add them to our calling block we defined in Step 2.

```
module "network_stuff" {
  source         = "./network"
  common_tags    = var.common_tags
  vpc_cidr_block =  var.vpc_cidr_block
  private_cidr_block =  var.private_cidr_block
  public_cidr_block =  var.public_cidr_block
}
```

and now we need to make a change to our module. we need to tell it about our new input variables, and we need to use them.

In our module directory we need to create a new file `input.tf` and add the following entries.

```
variable "common_tags" {
  type = map
  description = "A MAP of tags used by the resources"
  default = {
     Name = "Unknown"
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block of VPC"
}

variable "private_cidr_block" {
  description = "CIDR block of Private Subnet"
}

variable "public_cidr_block" {
  description = "CIDR block of Public Subnet"
}
```

I suggest that since this is a reusable module then we give the variables a description so it helps anyone using it in the future. Also where possible set default values, specially if you are adding a new variable to an already existing module.

### Step 3 - Fix missing output variables.

Since the moudle creates a VPC and SUBNETS which we need in the bastion, we need to return them. so in your module directory. create a file called `outputs.tf` and add the following block:

```
output "vpc_id" {
  value = aws_vpc.main.id
}

output public_subnet_id {
   value = aws_subnet.public.id
}

output private_subnet_id {
   value = aws_subnet.private.id
}
```

and we need to use these variables in the `bastion.tf` changing **aws_vpc.vpc_id** to **module.network_stuff.vpc_id** and **aws_subnet.public.id** to **module.network_stuff.public_subnet_id**


Once you have done this you will need to return to your projects parent directory and re-run `terraform init --upgrade`	


