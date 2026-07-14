# Day 4 - AWS Organizations, SCPs, and IAM Identity Center

Goal: Understand how a company centrally manages multiple AWS accounts,
workforce access, security guardrails, and billing.

## The One-Account Problem

Imagine development, testing, production, security, and finance teams sharing
one AWS account. A developer could accidentally affect production, experiments
could consume the production budget, permissions would be difficult to
separate, and nobody could clearly attribute costs.

This is not only an IAM problem. It is an account-boundary, governance,
security, operations, and billing problem. AWS accounts provide stronger
isolation boundaries as an environment grows.

## Core Story

A company separates workloads into multiple AWS accounts. AWS Organizations
manages those accounts centrally. Organizational units group accounts, SCPs set
maximum-permission guardrails, IAM Identity Center provides workforce access,
STS creates temporary sessions, and the management account receives the
consolidated bill.

## Key Concepts

| Concept | Meaning |
|---|---|
| AWS Organization | A collection of AWS accounts managed together |
| Organization Root | The top hierarchy container; it is not the AWS root user |
| Management account | Administers the organization and pays member-account charges |
| Member account | An account that normally contains workloads |
| Organizational unit | A logical group of accounts that inherit common policies |
| Service control policy | A guardrail that limits maximum available permissions |
| Permission set | An IAM permission template provisioned to assigned accounts |
| Cross-account role | A role trusted by another account and assumed through STS |
| Consolidated billing | Central payment and organization-wide cost visibility |

## Why Use Multiple Accounts?

- Isolate development, testing, and production workloads.
- Reduce the blast radius of mistakes or compromised credentials.
- Apply different controls to different environments.
- Track cost by account and workload.
- Keep normal workloads out of the management account.

## Organizational Units

An OU groups accounts that need common controls. Common patterns include:

- Environment: development, testing, production
- Function: security, shared services, workloads
- Compliance requirement
- Business unit

When an account moves into an OU, applicable policies attached to that OU and
its parents affect the account.

## SCPs Are Guardrails

An SCP defines the maximum permissions available to principals in affected
member accounts. It does not grant permissions.

```text
Effective permission =
identity policy or permission set allows
AND applicable SCP allows
AND no explicit deny
```

Important rules:

- An explicit deny in an SCP wins over an allow in a permission set.
- SCPs do not restrict users or roles in the management account.
- Keep `FullAWSAccess` unless you have designed and tested an allow-list model.
- Test a new SCP on a dedicated OU before wider rollout.
- Do not attach a training deny policy to the organization Root.

Example training SCP:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyS3BucketCreation",
      "Effect": "Deny",
      "Action": "s3:CreateBucket",
      "Resource": "*"
    }
  ]
}
```

## IAM Identity Center

IAM Identity Center gives workforce users one access portal for assigned AWS
accounts and applications.

Recommended approach:

- Assign access to groups instead of individuals where possible.
- Require MFA.
- Use least-privilege permission sets.
- Use temporary sessions instead of duplicate IAM users and access keys.

The Day 4 demonstration uses `AdministratorAccess` only to prove that an SCP
explicit deny can restrict even an administrator. Do not treat that broad
permission set as the production recommendation.

After an account and permission-set assignment, Identity Center provisions an
`AWSReservedSSO_...` role. Selecting the account and permission set in the
access portal creates an STS assumed-role session.

## Two Cross-Account Role Patterns

| Role pattern | Purpose |
|---|---|
| `AWSReservedSSO_CloudAdhar-Admin_...` | Identity Center access-portal session |
| `OrganizationAccountAccessRole` | Management-account access to a member account created through Organizations |

Both use temporary STS role sessions. Avoid shared keys and duplicate IAM users
across accounts.

## Consolidated Billing

- The management account pays member-account charges.
- Costs can be grouped and reviewed by linked account.
- Eligible usage-based pricing benefits may be shared.
- AWS Organizations has no additional service fee; resources are billed
  normally.
- New Cost Explorer or linked-account data may take time to appear.

## Check Your Understanding

1. Why is the organization Root different from the AWS root user?
2. Does attaching an SCP allow a user to call an AWS API?
3. What happens when a permission set allows an action but an applicable SCP
   explicitly denies it?
4. Why should normal workloads stay out of the management account?
5. Which role name indicates an Identity Center session?
