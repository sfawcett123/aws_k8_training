---
title: Cloud Init Config
nav_order: 40
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
[Cloud Init]( https://cloudinit.readthedocs.io/en/latest/) is a system to install and configure servers on inititalization. 


### Create a Resource

We need to use the `template_cloudinit_config` data type to create a file with the information we need to send to the server.

```

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = file("./templates/init.cfg")
  }
}
```

### Create config

Create a templates directory and a file called init.cfg, with your setting in it. An example below:

```
package_update: true
package_upgrade: true

packages:
   - awscli
   - python3
   - python3-pip

locale: en_GB.UTF-8
locale_configfile: /etc/default/locale

runcmd:
   - mkdir  "/run/install"
   - [ curl ,  "-s" , "https://bootstrap.pypa.io/pip/3.5/get-pip.py" ,  -o ,  /run/install/get-pip.py ]
   - python3  "/run/install/get-pip.py"
   - "LC_ALL=en_GB.UTF-8 pip3 install ansible"
   - pip3 install --upgrade awscli
   - pip3 install boto3


final_message: "The system is finally up, after $UPTIME seconds"
```

### Connect to your instance
You no longer need the `user_data = file("install.sh")` which can be replaced with

```
resource "aws_instance" "bastion" {
  ....
  user_data_base64            = data.template_cloudinit_config.config.rendered
  ....

}
```
