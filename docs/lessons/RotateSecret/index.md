---
title: Lambda Rotate Secret 
nav_order: 20
has_children: true
layout: page
parent: Guides
---

# Using Lambda to Rotate a Secret
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction
From time to time you want to keep API or SSH keys in AWS Secrets Manager, and then periodically rotate them. To do this you can associate a lambda function with the secret and allow it to automatically update the secret periodically or on demand.

In this demo we are going to use some AWS provided Python code to rotate a SSH Key, though in practice the language and process can be changed to suit your needs.

## Create a Secret

In AWS you need to navigate to the secrets manager and create your secret, in this case it needs to be a Key/Value secret with two entries, the Secrets can be empty, and at this time no other settings are required.

```
{ "PublicKey": "" ,
  "PrivateKey": "" }
```

## Create a Lambda Function

This is the complex bit we need to create and package a lambda function which will rotate the key, for our example, we need to select:

1. Author from Scratch
2. Runtime "Python 3.9" 
3. Architecture x86_64

This will create you a dummy function, and a dummy execution role. 

##  Package and Upload

In this case we have some [Python](https://github.com/sfawcett123/aws_k8_training/tree/main/AWS/lambda/KeyRotate) which will do the job, but we need to [bundle this into a zip file](https://github.com/sfawcett123/aws_k8_training/blob/main/docs/howto/lambda_pkg.md) and upload it into our function. 

## Role Permissions

Once uploaded you will need to set the permissions for the role. this is simply done by clicking on the role in AWS Lambda, which will take you to AWS IAM, where you can click on the **Policy** and edit it.

In our example it needs to look a little like; Note before you overwrite the defaulted policy, take a copy of the statement as you will need to reinstate these permissions

```
{
    "Version": "2012-10-17",
    "Statement": [
        ---
        --- NOTE Policy Defaulted needs to go here 
        ---
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:PutSecretValue",
                "secretsmanager:CreateSecret",
                "secretsmanager:UpdateSecretVersionStage",
                "secretsmanager:DeleteSecret",
                "secretsmanager:UpdateSecret"
            ],
            "Resource": "<ARN FOR SECRET>"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:PutSecretValue",
                "secretsmanager:CreateSecret",
                "secretsmanager:UpdateSecretVersionStage",
                "secretsmanager:DeleteSecret",
                "secretsmanager:UpdateSecret"
            ],
            "Resource": "<ARN FOR SECRET>"
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetRandomPassword",
                "secretsmanager:ListSecrets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": "ssm:SendCommand",
            "Resource": "arn:aws:ssm:*:*:document/AWS-RunShellScript"
        },
        {
            "Sid": "VisualEditor6",
            "Effect": "Allow",
            "Action": [
                "ssm:ListCommands",
                "ssm:ListCommandInvocations"
            ],
            "Resource": "*"
        }
    ]
}
```

### Attach function to Secret
Return to your secret and choose **Edit rotation configuration** where you can set the period and choose the Lambda rotation function, which should be the one you created.

Save all this, and try to rotate your function immediatly. this isn't actually immediatly it can take a few minutes as it is scheduled. but if you go to your Lambda function, and the monitoring section. you should eventually see a log file appear.

You could also look at your secrets, and they will now be populated.

