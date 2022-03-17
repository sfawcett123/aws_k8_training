---
title: Improve Bastion
nav_order: 30
has_children: true
layout: page
parent: Guides
---

# Improve Bastion
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction

We do not want to be manually installing tools on our bastion and we want to be able access our system using aws cli or ansible from the bastion.
## Goals

1. Implement a script that installs certain tools when the bastion is built.
1. Enable the Bastion to run AWS CLI without the need to configure users.
