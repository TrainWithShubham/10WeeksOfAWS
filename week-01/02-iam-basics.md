# Day 2 - IAM Basics

Today, understand how AWS decides who can access what.

Remember this:

> Identity + Permissions = Access

## IAM in Simple Words

Think of IAM like an office ID card system:

- User: one person with a login.
- Group: a team of users with same access.
- Role: temporary access for a task.
- Policy: the rules that say allowed or denied.

## IAM User

An IAM user is a named identity for a person or workload.

For example:

- `learner-s3` can get S3 read-only access.
- `learner-ec2` can get EC2 read-only access.
- `learner-billing` can get billing read-only access.

Login access does not mean full AWS access. Permissions decide what the user can
do.

## IAM Group

An IAM group is a collection of users with common permissions.

Examples:

- `S3ReadOnlyGroup` uses `AmazonS3ReadOnlyAccess`.
- `EC2ReadOnlyGroup` uses `AmazonEC2ReadOnlyAccess`.
- `BillingViewGroup` uses `AWSBillingReadOnlyAccess`.

Better approach: attach policies to groups, then add users to groups.

## IAM Role

An IAM role gives temporary credentials to a trusted identity.

Used when:

- AWS service accessing another AWS service.
- GitHub Actions accessing AWS using OIDC.
- A user switching into a role for temporary access.

For Week 1, just remember this: roles are for temporary access. You do not need
to master roles before doing the user and group labs.

## IAM Policy

An IAM policy is a JSON document that defines permissions.

Types:

- AWS managed policy: created and maintained by AWS.
- Customer managed policy: created by you and reusable.
- Inline policy: attached directly to one identity.

## Least Privilege

Give only the permissions required to complete the task.

Example:

- If a user only needs to view EC2, use read-only access.
- Do not give full access for a read-only requirement.

## Permission Boundary

A permission boundary defines the maximum permissions an IAM user or role can
have.

It does not grant permissions by itself. It only limits the maximum possible
permissions.

For now, remember only this: a permission boundary is a maximum limit. We will
go deeper later.
