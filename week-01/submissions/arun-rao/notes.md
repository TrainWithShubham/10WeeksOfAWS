# Week 01 Notes — Arun Rao

## Root User Security

The AWS root user has unrestricted access to all resources and settings in an AWS account, including sensitive billing and account-management operations. Using it for everyday tasks increases the risk of accidental changes, security breaches, and unauthorized access if credentials are compromised.

**Best practices applied:**
- Enabled MFA on root account immediately after account creation
- Created a separate IAM admin user for daily operations
- Root user credentials are stored securely and not used for routine tasks

## Billing & Cost Management

AWS billing should be monitored from day one to avoid unexpected charges. Even during learning/testing, resources like EC2 instances, RDS databases, NAT Gateways, and storage can incur costs if left running.

**Best practices applied:**
- Enabled billing alerts in Account Preferences
- Set up a $5 CloudWatch billing alarm as an early warning
- Subscribed to SNS email notifications for the alarm

## IAM Fundamentals

IAM (Identity and Access Management) is the AWS service for controlling who can do what in your account. Key concepts:

- **Users**: Individual identities (people or services)
- **Groups**: Collections of users that share the same permissions
- **Policies**: JSON documents defining allowed/denied actions on resources
- **Roles**: Identities assumed temporarily by users, services, or external identities (OIDC)

**Principle of Least Privilege**: Always grant only the minimum permissions needed. The custom S3 policy is an example — it only allows read access to one specific bucket rather than granting full S3 access.

## Custom IAM Policy

The `CustomS3ReadOnlyTrainingPolicy` policy is scoped tightly:
- `s3:ListAllMyBuckets` on `*` — needed to enumerate bucket names
- `s3:ListBucket` on `arn:aws:s3:::tests3tes` — list objects in the specific bucket
- `s3:GetObject` on `arn:aws:s3:::tests3tes/*` — download objects from the specific bucket

No write, delete, or admin actions are included.

## OIDC & GitHub Actions

OIDC (OpenID Connect) allows GitHub Actions workflows to assume an AWS IAM role without storing long-lived AWS credentials as GitHub secrets. The workflow requests a short-lived token from GitHub's OIDC provider, presents it to AWS STS, and receives temporary credentials scoped to the IAM role.

**Why this is better than using access keys:**
- No long-lived secrets stored in GitHub
- Credentials are short-lived (expire after the workflow run)
- Scope is limited to the specific repo and workflow via trust policy conditions

**Trust policy key fields:**
- `Principal.Federated`: the ARN of the GitHub OIDC provider registered in IAM
- `Condition.StringEquals`: locks the audience claim to `sts.amazonaws.com`
- `Condition.StringLike`: locks the subject claim to a specific repo (`Nurarao/aws-oidc-challenge`)

## Key Takeaways

1. Never use the root account for day-to-day work
2. Enable MFA everywhere possible
3. Monitor billing from day one
4. Follow least-privilege for all IAM policies
5. Prefer OIDC over long-lived access keys for CI/CD pipelines
