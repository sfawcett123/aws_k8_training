---
title: Create a VPC
nav_order: 20
parent: AWS Bastion
layout: page
---

# Create a VPC
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
So what is a Virtual Private Cloud (VPC) ? Well simply put it is a container. We define the IP address range of this container using a [CIDR block](https://www.ipaddressguide.com/cidr).

The [CIDR block](https://www.ipaddressguide.com/cidr), simply allows us to define the size of our VPC in relation to the number of IP addresses we use. so for example 10.0.0.0/16 allows IP address from 10.0.0.1 through to 10.0.255.254, which is 65534 IP addresses. 

## Create a VPC

### VPC File
Create a file called `vpc.tf` which we will enter the details of our vpc. there are only 3 settings we will really need at the moment. two of them are just to enable DNS and the main setting defines the [CIDR block](https://www.ipaddressguide.com/cidr).

```
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
```

### Apply 
Lets build this using the command `terraform apply`

```
❯ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_vpc.main: Creating...
aws_vpc.main: Still creating... [10s elapsed]
aws_vpc.main: Creation complete after 12s [id=vpc-0976a5969b6a65f09]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

from now on I do not intend on displaying the output of the terraform command, as it does get big. 
