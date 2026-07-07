# Day 1 - Cloud Foundations

Goal: Understand how AWS is organized and what AWS manages versus what you
manage.

## Before You Start

Before opening AWS, write answers in your own words:

1. What is a Region? --> 
2. What is an Availability Zone? -->
3. What is one thing AWS secures? -->
4. What is one thing you must secure? -->


## AWS Global Infrastructure

AWS infrastructure is built using:

- Region: a geographic area where AWS has multiple data centers.
- Availability Zone: an isolated data center location inside a Region.
- Edge Location: a location used by services like CloudFront to serve users
  faster.

Exam pointer:

- Use multiple Availability Zones for high availability.
- Use CloudFront and Edge Locations for low-latency content delivery.

## Shared Responsibility Model

AWS security is shared between AWS and the customer.

- AWS is responsible for security of the cloud.
- You are responsible for security in the cloud.

Examples:

- AWS manages data centers, hardware, networking, and managed service
  infrastructure.
- You manage IAM, permissions, data, applications, network rules, and EC2 guest
  OS patching.

Simple line:

> AWS secures the cloud. You secure what you build in the cloud.

## Root User

The root user owns the AWS account and has full access to everything.

Best practices:

- Enable MFA on root user.
- Do not use root user for daily work.
- Create IAM users or roles for regular tasks.
- Monitor billing from the beginning.

Use the root user only for account-level setup like MFA and billing. After that,
avoid using it for daily practice.
