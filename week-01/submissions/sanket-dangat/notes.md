# Cloud Foundations

## Key Concepts

### 1. AWS Global Infrastructure

AWS infrastructure is built using:

- **Regions** — geographic locations where AWS has multiple data centers.
- **Availability Zones** — isolated data center locations inside a Region.
- **Edge Locations** — locations used by services like CloudFront to deliver content closer to users.

**Exam pointer:**  
For high availability, design across multiple Availability Zones. For low latency content delivery, use CloudFront and Edge Locations.

---

### 2. Shared Responsibility Model

AWS security is shared between AWS and the customer.

- AWS is responsible for **security of the cloud**.
- Customer is responsible for **security in the cloud**.

Example:

- AWS manages global infrastructure, data centers, hardware, and managed service infrastructure.
- You manage IAM users, permissions, data, application security, network configuration, and guest OS patching for EC2.

**Simple line:**  
AWS secures the cloud. You secure what you build in the cloud.

---

### 3. Account and Root User

The root user is the account owner identity and has full access to everything in the AWS account.

Best practices:

- Enable MFA on root user.
- Do not use root user for daily work.
- Create IAM users or roles for regular tasks.
- Monitor billing from the beginning.

---

# IAM Fundamentals

## Key Concepts

### 1. IAM Users, Groups, Roles, and Policies

IAM controls who can sign in and what actions they can perform.

**Identity + Permissions = Access**

- **IAM User** — named identity for a person or workload that needs AWS access.
- **IAM Group** — collection of users with common permissions.
- **IAM Role** — temporary permissions for AWS services or trusted identities.
- **IAM Policy** — JSON document that defines allowed or denied actions.

---

### 2. IAM Users

An IAM user is used when a person or workload needs AWS access.

Example:

- `learner-s3` user can be given S3 read-only access.
- `learner-ec2` user can be given EC2 read-only access.
- `learner-billing` user can be given billing view access.

Important point:

Having login access does not mean having full AWS access. Permissions decide what the user can do.

---

### 3. IAM Groups

IAM groups help manage permissions for multiple users together.

Examples:

- `S3ReadOnlyGroup` → attach `AmazonS3ReadOnlyAccess`
- `EC2ReadOnlyGroup` → attach `AmazonEC2ReadOnlyAccess`
- `BillingViewGroup` → attach `AWSBillingReadOnlyAccess`

Best practice:

Attach policies to groups and add users to groups. This is easier to manage than attaching policies to each user individually.

---

### 4. IAM Roles

IAM roles provide temporary credentials. They are commonly used when AWS services need to access other AWS services.

Example:

A trusted identity needs temporary access to AWS without using long-lived access keys.

Key point:

IAM roles are used for temporary access. In this Week 1 challenge, focus on understanding role assumption and OIDC-based access.

---

### 5. IAM Policies

IAM policies define permissions using JSON.

Common policy types:

- **AWS Managed Policy** — created and maintained by AWS. Example: `AmazonS3ReadOnlyAccess`.
- **Customer Managed Policy** — created by you and reusable across users, groups, and roles.
- **Inline Policy** — directly embedded into one user, group, or role.

Best practice:

Use customer managed policies when you need reusable custom permissions. Use inline policies only for very specific one-to-one use cases.

---

### 6. JSON Policy Structure

A basic IAM policy includes:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::example-bucket/*"
    }
  ]
}
```

Meaning:

- `Version` — policy language version.
- `Statement` — permission block.
- `Effect` — Allow or Deny.
- `Action` — AWS API action.
- `Resource` — AWS resource where action is allowed or denied.
- `Condition` — optional rules for when policy applies.

---

### 7. Least Privilege

Least privilege means giving only the permissions required to complete the task, nothing extra.

Example:

If a user only needs to view EC2 instances, do not give `AmazonEC2FullAccess`. Give read-only access.

Simple line:

Give enough access to do the work, but not enough access to create damage.

---

### 8. Permission Boundaries

A permission boundary defines the maximum permissions an IAM user or role can have.

Important:

- Permission boundary does not grant permissions by itself.
- It only limits the maximum possible permissions.
- Effective permission is the intersection of identity policy and permission boundary.

Example:

If the identity policy allows only `s3:GetObject`, and the permission boundary allows `s3:*`, the user can still only do `s3:GetObject`.

---