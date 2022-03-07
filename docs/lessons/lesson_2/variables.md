---
title: Variables
nav_order: 20
parent: Drying Terraform Out
layout: page
---

# Variables
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction

There are two types of variables. 

### Local Variables
These variables are set withing the terraform, but cannot be overwritten extrernally. We will deal with these a little later.

### Input Variables
Input variables are variables we can define and give default values for inside the terraform, but also can be overriden by setting environment variables or inside a input variable file.

#### Create a Variable

Create a file called `variables.tf` and in there define a variable `instance_type` which you default to **t2.micro** 

```
variable instance_type {
   default = "t2.micro"
}
```

#### Use Variable

Edit the bastion.tf file and change the hard coded ```instance_type = "t2.micro"``` to ```instance_type = var.instance_type ```

If you run terraform plan now ( no need to build it ) you will see that it plans to build a new aws_instance with a t2.micro type.  

If though we set the environment variable `export TF_VAR_instance_type="t3.large"` and then rerun the plan, we will see that the environment variable has overriden the default. 

We can also set variables on the command line as we run the plan, `terraform plan -var "instance_type=PIE"`

Also we can use a variable file for example "production.tfvar" and set the variable in that. `terraform plan -var-file=production.tfvar`

Be aware of the precisdence of variables. The lowest being the default, then the command line var or var-file, this can depend on what order they are put on the command line, and finally the TF_VAR environment variable.

### Variable Types

Variables do not have to be just strings and numbers, they can be maps and lists. One great use for map variables is in the use of TAGS ( when supported ).

In you `variables.tf` file create an entry. 

```
variable common_tags {
   type = map
   default = {
          "Project"  = "My Project"
          "Owner"    = "Steve Fawcett"
   }
}
```

Note, how you have to tell a variable it is a map variable.

Now with an AWS provider, and Azure it is possible to set all your objects to have the same value,  by simpy adding `tags = var.common_tags` to all resources that support tagging.

Maps have some other clever usages too, which we will return too.

### Clean up

In `subnets.tf` we have some hardcoded CIDR blocks, lets replace them with variables. **public_cidr_block** and **private_cidr_block**

And in `vpc.tf` create a variable called **vpc_cidr_block**


