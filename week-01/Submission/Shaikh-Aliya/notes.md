# AWS Week1 notes

## What is AWS?

AWS (Amazon Web Services) is a cloud computing platform provided by Amazon. It offers services like virtual servers, storage, databases, and networking over the internet, allowing businesses to build and run applications without managing physical hardware.

---

## What is a Region?

A Region is a geographical location where AWS has multiple Availability Zones (data centers). Each Region is independent and helps deploy applications closer to users.

**Examples:** Mumbai (ap-south-1), London (eu-west-2), Ohio (us-east-2)

---

## What is an Availability Zone (AZ)?

An Availability Zone (AZ) is one or more isolated data centers within an AWS Region. Using multiple AZs improves high availability and fault tolerance.

---

## What is MFA (Multi-Factor Authentication)?

MFA (Multi-Factor Authentication) adds an extra layer of security to your AWS account. Even if someone knows your password, they must also provide a one-time verification code to access the account.

---

## What is a Billing Alert?

A Billing Alert helps monitor AWS spending. By configuring AWS Billing with Amazon CloudWatch, you can receive notifications when your AWS bill exceeds a specified amount.

---

## What is IAM?

IAM (Identity and Access Management) is an AWS service used to securely manage users, roles, groups, and permissions. It controls who can access AWS resources and what actions they can perform.

---

## IAM User

An IAM User represents a person or application that needs access to AWS. Each user has their own login credentials and assigned permissions.

---

## IAM Group

An IAM Group is a collection of IAM users. Instead of assigning permissions to each user individually, permissions are assigned to the group, and all members inherit those permissions.

---

## IAM Role

An IAM Role provides temporary permissions to users, AWS services, or applications. Roles do not have permanent credentials, making them a secure way to grant temporary access.

---

## IAM Policy

An IAM Policy is a JSON document that defines permissions in AWS.

A policy mainly contains:

- Effect – Allow or Deny
- Action – What actions are allowed or denied
- Resource – Which AWS resource the action applies to
- Condition (Optional) – Additional rules for granting access

---

## Least Privilege Principle

The Principle of Least Privilege means giving users only the minimum permissions required to perform their tasks. This reduces security risks and prevents unnecessary access.

---

## Permission Boundary

A Permission Boundary defines the maximum permissions that an IAM user or role can receive. Even if additional permissions are granted, they cannot exceed the boundary.

---

## GitHub OIDC (OpenID Connect)

GitHub OIDC (OpenID Connect) allows GitHub Actions to securely authenticate with AWS without storing AWS Access Keys or Secret Keys in GitHub Secrets.

### How GitHub OIDC Works with AWS

1. GitHub Actions requests an OIDC identity token.
2. AWS verifies the token.
3. AWS allows GitHub Actions to assume an IAM Role.
4. Temporary AWS credentials are issued.
5. GitHub Actions securely accesses AWS resources.

### Benefits of GitHub OIDC

- No long-term AWS Access Keys.
- More secure authentication.
- Temporary credentials.
- Better security for CI/CD pipelines.
- Easier credential management.
