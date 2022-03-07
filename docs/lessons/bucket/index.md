---
title: S3 Bucket
nav_order: 12
layout: page
---

# S3 Buckets
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction

When terraform runs it produces a state file, this file needs to be kept and maintained. It is also important that you do not corrupt this file, so it is adviced that you save it in a version controlled environment. Since we are using AWS then logically an S3 bucket would be the ideal place.

### Create

```
❯ aws s3api create-bucket --bucket sf-testbucket-191  --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
{
    "Location": "http://sf-testbucket-191.s3.amazonaws.com/"
}
```

### Enable versioning

```
aws s3api put-bucket-versioning --bucket sf-testbucket-191 --versioning-configuration Status=Enabled
```

### Delete

```
aws s3api delete-bucket --bucket sf-testbucket-191
```