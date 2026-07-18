# Week 2 - Day 4: AWS Organizations, SCPs, and IAM Identity Center

Organization, Root, management account, member account, and OU
  An AWS Organization is a way to manage multiple AWS accounts from one place.

  The Management Account is the primary account that owns the AWS Organization. It's mainly used for managing accounts, billing, and applying organization-wide policies rather than running workloads. From these accounts you can create new     AWS accounts or invite existing accounts.

  An Organizational Unit, or OU, is simply a logical way of grouping AWS accounts.Instead of applying policies to individual accounts one by one, you can group similar accounts together and apply policies at the OU level.


Why an SCP is a guardrail rather than a permission grant?

  An SCP (Service Control Policy) is a guardrail because it defines the maximum permissions an AWS account can have. It doesn't grant any permissions by itself. Actual permissions are granted through IAM policies attached to users, groups,    or roles.


Why IAM Identity Center is preferred over duplicate IAM users?
  IAM Identity Center is preferred over creating duplicate IAM users because it provides centralized authentication and authorization across multiple AWS accounts.

The difference between a permission set and an SCP
  A Permission Set defines what a user can do   after logging in through IAM Identity Center, whereas an SCP defines the maximum permissions that any account, user, or role in an AWS account can have.

Why S3 creation worked before the account move and failed afterward

  Initially the dev-account was under the Root folder which had fullaccess permission of the AWS account, Therefore we were able to create the s3 bucket.
  But when we moved the dev-account from the Root Folder to the DEV-OU which we created, The DEV-OU had a SCP attached to it which denied creating s3 bucket for all Resources.
  When we moved the dev-account into the DEV-OU, It inherited the Policy which is attached to the OU. Hence, when we tried to create bucket after we moved the account in OU it threw the error.


What you learned about consolitated billing?
  Consolidated Billing is an AWS Organizations feature that lets a company combine the bills of multiple AWS accounts into a single monthly invoice. Instead of each account receiving its own bill, the Management Account receives one           consolidated bill while each account continues to operate independently.
