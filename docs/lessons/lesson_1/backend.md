---
title: Backend 
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

We need to initialise the terraform provider and configure the AWS S3 bucket in preperation for the state file.

## Provider

create a file called **provider.tf**

```
provider "aws" {
  region = "eu-west-1"
}

```

## Backend

create a file called **backend.tf** you can change the region to what suits you, andthe name of the bucket should be the one you created as part of the pre-requisits. The key can be any valid name you like.

```
terraform {
  backend "s3" {
    region  = "eu-west-1"            
    bucket  = "<YOUR BUCKET NAME>"
    key     = "global/s3/terraform.tfstate"
    encrypt = true
  }
}
```

### Initialization

We have to initialise the terraform environment and statefiles, with the command `terraform init `

```
❯ terraform init

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v4.3.0...
- Installed hashicorp/aws v4.3.0 (self-signed, key ID 34365D9472D7468F)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
