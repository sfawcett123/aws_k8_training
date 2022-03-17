---
title: Drying Terraform Out 
nav_order: 20
has_children: true
layout: page
parent: Guides
---

# Drying Terraform Out 
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## Introduction

Don't Repeat Yourself (DRY) is a solid foundation for a lot of code. Using Reusable code and not constantly reinventing the same routines, helps with continous improvement and application security.

What can help DRY out terraform?

1. Use of variables
2. Use of Modules
3. Tagging

## Goals

The plan is to take the code written in Lesson 1 and, allow it to be re-used but with different settings by using terraform variables, then by turnining a lot of it into a reusable module. 

Tagging is important so we can find our resources in AWS, as they could all look the same if we are reusing the same methods, and we could find it dificult to identify what resource belongs to which project.
