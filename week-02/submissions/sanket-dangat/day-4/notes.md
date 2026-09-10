# AWS Organizations, SCPs, and IAM Identity Center

## The One-Account Problem

Using a single AWS account for Development, Testing, Production, Security, and Finance creates several problems:

- Accidental changes can impact production.
- Development activities may consume the production budget.
- Permissions become difficult to manage.
- Cost tracking becomes unclear.
- Security risks increase due to shared access.

AWS accounts provide strong isolation and are the recommended boundary for security, governance, operations, and billing.

---

# Core Architecture

A company separates workloads into multiple AWS accounts.

AWS Organizations centrally manages those accounts.

- Organizational Units (OUs) group accounts with similar governance requirements.
- Service Control Policies (SCPs) define organization-wide permission guardrails.
- IAM Identity Center provides centralized workforce access.
- AWS STS issues temporary security credentials.
- The Management Account receives the consolidated AWS bill.

> **Note:** Service Control Policies (SCPs) are available only when AWS Organizations is enabled with **All Features**.

---

# Key Concepts

| Concept | Description |
|---------|-------------|
| AWS Organization | Collection of AWS accounts managed together |
| Organization Root | Top-level hierarchy container (not the AWS root user) |
| Management Account | Administers the organization and pays the consolidated bill |
| Member Account | AWS account that hosts workloads |
| Organizational Unit (OU) | Groups AWS accounts for governance |
| Service Control Policy (SCP) | Defines the maximum permissions available |
| Permission Set | IAM Identity Center permission template |
| Cross-Account Role | IAM role assumed through AWS STS |
| Consolidated Billing | Centralized billing across AWS accounts |

---

# Why Use Multiple AWS Accounts?

Using separate AWS accounts provides:

- Environment isolation
- Reduced blast radius
- Better security
- Clear cost tracking
- Independent service quotas
- Centralized governance
- Safer production environments

> **Best Practice:** Keep production workloads separate from development and testing.

---

# AWS Organizations

AWS Organizations enables centralized management of multiple AWS accounts.

## Features

- Create and manage AWS accounts
- Organizational Units (OUs)
- Service Control Policies (SCPs)
- Consolidated Billing
- Central governance
- Shared pricing benefits

---

# Organizational Units (OUs)

Organizational Units group accounts that require common governance and security controls.

Common structures include:

- Environment-based
- Function-based
- Business unit
- Compliance-based

Example:

```text
Organization Root
│
├── Infrastructure
│   ├── Security
│   └── Shared Services
│
└── Workloads
    ├── Development
    ├── Testing
    └── Production
```

When an account moves into an OU, it inherits the policies attached to that OU and all parent OUs.

---

# Service Control Policies (SCPs)

An SCP defines the **maximum permissions** available within affected member accounts.

**SCPs never grant permissions.**

## Permission Evaluation

```text
Request succeeds only if:

✓ IAM policy (or Permission Set) allows
✓ Resource policy (if applicable) allows
✓ SCP does NOT deny
✓ Permission boundary (if used) allows
✓ Session policy (if used) allows
✓ No explicit deny anywhere
```

> **Remember:** SCPs only limit permissions. They never grant permissions.

---

## SCP Evaluation Hierarchy

```text
Organization Root
        │
        ▼
Parent OU
        │
        ▼
Child OU
        │
        ▼
Member Account
```

All applicable SCPs are evaluated together.

**Any Explicit Deny = Access Denied**

---

## Important Rules

- SCPs never grant permissions.
- Explicit Deny always overrides Allow.
- SCPs affect only member accounts.
- SCPs do not restrict the Management Account.
- Service-linked IAM roles are generally not restricted by SCPs.
- Test SCPs on a dedicated OU before production.
- Keep `FullAWSAccess` unless intentionally using an allow-list model.
- Avoid attaching experimental SCPs to the Organization Root.

---

## Example SCP

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

---

# IAM Identity Center

IAM Identity Center provides centralized workforce access to AWS accounts and applications.

Instead of creating IAM users in every account, users authenticate once and receive temporary credentials.

## Best Practices

- Assign Permission Sets to groups instead of individual users.
- Enable Multi-Factor Authentication (MFA).
- Follow the Principle of Least Privilege.
- Use temporary STS credentials.
- Avoid long-term access keys.

---

## Permission Sets

A Permission Set is a reusable IAM permission template assigned through IAM Identity Center.

Examples:

- AdministratorAccess
- ReadOnlyAccess
- Custom Permission Set

> **Note:** AdministratorAccess is commonly used for demonstrations to show that an SCP Explicit Deny overrides administrator permissions. It should not be the default production permission.

---

## IAM Identity Center Login Flow

```text
User
 │
 ▼
IAM Identity Center
 │
 ▼
Permission Set
 │
 ▼
AWSReservedSSO Role
 │
 ▼
AWS STS
 │
 ▼
Temporary Security Credentials
 │
 ▼
AWS Account
```

When a Permission Set is assigned to an AWS account, IAM Identity Center automatically creates an IAM role similar to:

```text
AWSReservedSSO_<PermissionSet>_<RandomString>
```

inside the target AWS account.

---

# AWS STS

AWS Security Token Service (STS) provides temporary security credentials.

Benefits:

- No long-term credentials
- Automatic credential expiration
- Secure cross-account access
- Centralized authentication

---

# AWSReservedSSO_* vs OrganizationAccountAccessRole

| AWSReservedSSO_* | OrganizationAccountAccessRole |
|------------------|-------------------------------|
| Created automatically by IAM Identity Center | Created automatically by AWS Organizations |
| Used by workforce users | Used by the Management Account |
| Permissions come from Permission Sets | Cross-account administrator role |
| Access begins through the IAM Identity Center portal | Used for organization administration |
| Uses temporary AWS STS credentials | Uses temporary AWS STS credentials |

---

# Consolidated Billing

AWS Organizations combines billing for all member accounts.

Benefits:

- Single monthly bill
- Cost visibility by linked account
- Shared usage-based pricing benefits
- Centralized financial management

---

# Best Practices

- Use separate AWS accounts for each environment.
- Keep production isolated.
- Keep workloads out of the Management Account.
- Apply SCPs as guardrails.
- Test SCPs before deployment.
- Assign access through IAM Identity Center.
- Use groups instead of individual assignments.
- Enable MFA.
- Use temporary credentials.
- Follow the Principle of Least Privilege.

---

# Interview Questions

### 1. Why is the Organization Root different from the AWS root user?

- Organization Root is the top-level container in AWS Organizations.
- AWS Root User is the administrative user of a single AWS account.

---

### 2. Does attaching an SCP allow a user to call an AWS API?

No.

An SCP never grants permissions. It only defines the maximum permissions available to member accounts.

---

### 3. What happens when a Permission Set allows an action but an applicable SCP explicitly denies it?

The request is denied.

An Explicit Deny in an SCP always overrides IAM policies and Permission Sets.

---

### 4. Why should normal workloads stay out of the Management Account?

The Management Account should be dedicated to:

- AWS Organizations administration
- Central governance
- Consolidated billing
- Organization management

Keeping workloads out reduces security risk and follows AWS best practices.

---

### 5. Which role indicates an IAM Identity Center session?

```text
AWSReservedSSO_<PermissionSet>_<RandomString>
```

---

### 6. Explain IAM Identity Center Permission Sets and Temporary STS Access.

Permission Sets define the permissions users receive when accessing AWS accounts.

Workflow:

1. User signs in to IAM Identity Center.
2. Selects an AWS account.
3. IAM Identity Center applies the assigned Permission Set.
4. AWS STS issues temporary credentials.
5. User accesses AWS resources.

---

### 7. Explain the difference between an IAM permission and an SCP guardrail.

| IAM Policy | SCP |
|------------|-----|
| Grants permissions | Limits maximum permissions |
| Attached to users, groups, or roles | Attached to Organizations, OUs, or accounts |
| Works within one AWS account | Applies across multiple AWS accounts |
| Can Allow or Deny | Never grants permissions |

---

## 8. Explain AWSReservedSSO_* vs OrganizationAccountAccessRole

Both are IAM roles that use **AWS STS** for temporary credentials, but they serve different purposes.

| AWSReservedSSO_* | OrganizationAccountAccessRole |
|------------------|-------------------------------|
| Created automatically by IAM Identity Center | Created automatically by AWS Organizations |
| Created when a Permission Set is assigned to an AWS account | Created when an account is created through AWS Organizations (default behavior) |
| Used by workforce users | Used by the Management Account |
| Access begins through the IAM Identity Center portal | Used for administrative access between AWS accounts |
| Permissions come from the assigned Permission Set | Typically provides administrator access for organization management |
| Uses temporary STS credentials | Uses temporary STS credentials |

---

# Quick Revision

- AWS Organizations → Manage multiple AWS accounts
- Organization Root → Top-level hierarchy container
- Organizational Unit → Groups AWS accounts
- SCP → Maximum permissions
- IAM Policy → Grants permissions
- IAM Identity Center → Workforce access
- Permission Set → IAM permission template
- AWSReservedSSO_* → Identity Center role
- AWS STS → Temporary credentials
- OrganizationAccountAccessRole → Cross-account administration
- Consolidated Billing → One bill for all accounts

---