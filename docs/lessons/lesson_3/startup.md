---
title: Startup Script
nav_order: 20
parent: Improve Bastion
layout: page
---

# Startup Script
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
Run a shell script when a Linux server is first deployed

### Create Shell Script
We need to create a script, this can be anywhere or anyname but in our example I created a script called `install.sh`. The script needs to be executable.

```
touch install.sh
chmod +x install.sh
```

The script should contain the following lines, which will identify it as a bash shell script, update the system ( assuming it uses the apt-get package manager ) and then installs awscli. Please note we have no ability to interact with the script so any prompts need to be overriden.

```
#!/bin/bash

sudo apt-get update
sudo apt-get --assume-yes install awscli
```

### Attach the Scripts

Now we need to make sure the script runs when the instance is initiated, and we do this by adding the following line to the resource block.

```
resource "aws_instance" "bastion" {

  ....
  ....
  
  user_data                   = file("install.sh")
  
}
``` 

### Redeploy
We can now redeploy the script and when we ssh into the server, if we type `aws --version` we will see that the cli is deployed but we cannot use it unless we set up a configuration. Try `aws ec2 --region eu-west-1 describe-instances` and you will get an error, whic we will fix in the next lesson.


