---
title: Create Key Pair
nav_order: 60
parent: AWS Bastion
layout: page
---

# Create Key Pair
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
A key pair is a PRIVATE/PUBLIC key pair, where the public part is attached to the Bastion server and the private part is kept local. This allows you to pass the private key to the ssh command and it will validate your login.

## Generate Keys

To generate a private key and public keys you need to issue the commands:

```
openssl genpkey -algorithm RSA  -outform PEM -out SSH-Key.pem
chmod 0400 SSH-Key.pem
ssh-keygen -e -f SSH-Key.pem > public_key.pem
echo "*.pem" >> .gitignore
```

## Attach Key to Bastion

To use the new key you have created it needs to be added to the bastion server. To do this edit the `bastion.tf` file and add the following block:

```
resource "aws_key_pair" "generated_key" {
  key_name   = "SSH-Key"
  public_key = file("./public_key.pem")
}
```

This assumes you put your public key in the local file public_key.pem. You now have to associate this key with the bastion server, by changing the bastion.tf aws_instance to:

```
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name

}
```

Running apply on this, will destroy the instance and recreate it, so you will probably get a new IP address. but once the instance has restarted you can run the command:

```
ssh -i SSH-Key.pem ubuntu@x.x.x.x
```

where x.x.x.x is your IP address, and you should connect.



