---
title: Connect AWS CLI
nav_order: 20
parent: How To
layout: page
---

# Connect AWS CLI
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Set up connection

The advised way to set up a connection to AWS is use the [Configuration and credential file settings]( https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) 

Simply issung the command:

```
❯ aws configure
```

and entering your Access Key details, this will store your connection in a file `~/.aws/credentials` , which can automatically be found by Terraform and the AWS cli.

## Assumed Roles

It maybe that your AWS account requires you to assume a role and you may need to connect using the `aws sts assume-role` command. 

```
ACCOUNT=<Account Name to assume>
ROLE=<Role Name to Assume>
MFA=arn:aws:iam::84xxxxxxx56:mfa/UserName
OTP=<Output from MFA Device>

developer_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::${ACCOUNT}:role/${ROLE}" \
                    --role-session-name "${ROLE}" \
                    --serial-number ${MFA} \
                    --token-code ${OTP} \
                    --output json )
export AWS_ACCESS_KEY_ID=$(echo $developer_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $developer_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $developer_role | jq -r .Credentials.SessionToken)
```
