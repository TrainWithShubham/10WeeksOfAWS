# Week 2 - Day 4: AWS Organizations, IAM Identity Center & SCP

## Name
Priyanka Singh

## Topics Practiced

- AWS Organizations
- Organizational Units (OU)
- Service Control Policies (SCP)
- IAM Identity Center
- Permission Sets
- AWS STS
- Consolidated Billing

## What I Built

- Created an AWS Organization.
- Added a member account (`code0ps-dev`).
- Created a `Dev-Env` OU.
- Attached an SCP to deny S3 bucket creation.
- Configured IAM Identity Center with an Administrator permission set.
- Verified that S3 bucket creation worked before moving the account into the OU and failed after the SCP was applied.

---

## Concepts Learned

### Organization, Root, Management Account, Member Account & OU

- **Organization** manages multiple AWS accounts.
- **Root** is the top-level container.
- **Management Account** manages the organization.
- **Member Account** runs workloads.
- **OU** groups accounts so policies can be applied together.

### Why is an SCP a Guardrail?

An SCP **does not grant permissions**. It only limits what accounts are allowed to do. An explicit **Deny** always overrides IAM permissions.

### Why IAM Identity Center?

IAM Identity Center provides centralized access to multiple AWS accounts using one user and temporary credentials instead of creating IAM users in every account.

### Permission Set vs SCP

| Permission Set | SCP |
|----------------|-----|
| Grants permissions | Restricts permissions |
| Assigned to users | Attached to Root, OU, or Account |
| Similar to IAM policies | Organization-level guardrail |

### Why Did Bucket Creation Fail?

Before moving the account into `Dev-Env`, no SCP applied, so bucket creation succeeded.

After moving the account into the OU, the SCP explicitly denied `s3:CreateBucket`, resulting in **AccessDenied**.

### Consolidated Billing

AWS Organizations combines billing from all member accounts into a single bill managed by the Management Account while still showing account-wise costs.

---

## SCP Used

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyCreateBucket",
      "Effect": "Deny",
      "Action": "s3:CreateBucket",
      "Resource": "*"
    }
  ]
}
```

---

## Diagrams

![alt text](<aws-organizations-architecture.drawio (1).png>)

## Key Takeaways

- Learned how AWS Organizations manages multiple accounts.
- Understood the difference between Permission Sets and SCPs.
- Verified that **Explicit Deny** in an SCP overrides Administrator permissions.
- Learned how IAM Identity Center simplifies multi-account access.
- Understood the basics of consolidated billing.