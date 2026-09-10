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

# IAM Interview Questions and Answers

## 1. What is the difference between a Region and an Availability Zone?

- **Region:** A Region is a geographical area that contains multiple Availability Zones.
- **Availability Zone (AZ):**  An Availability Zone is one or more isolated data centers within a Region.

**Example:**
- Region: `us-east-1`
- Availability Zone: `us-east-1a`

---

## When should you use CloudFront and Edge Locations?

Use **Amazon CloudFront** when you need to deliver content to users with **low latency, high performance, and improved security**. CloudFront is ideal for:

- Caching static and dynamic content closer to users.
- Delivering websites, APIs, videos, and downloadable files faster.
- Reducing traffic and load on the origin server.
- Providing secure content delivery using HTTPS, AWS Shield, and AWS WAF.
- Serving a global audience with consistent performance.

**Edge Locations** are AWS data centers distributed around the world where CloudFront caches copies of your content. When a user requests content, CloudFront serves it from the **nearest Edge Location** whenever possible, reducing latency and improving the user experience.

---

## 3. What does AWS manage in the Shared Responsibility Model?

AWS is responsible for **Security of the Cloud**, including:

- Physical data centers
- Networking infrastructure
- Servers and storage hardware
- Global AWS infrastructure
- Hypervisor
- Managed service infrastructure

---

## 4. What does the customer manage in the Shared Responsibility Model?

Customers are responsible for **Security in the Cloud**, including:

- IAM users, groups, and roles
- Application security
- Operating system patches (EC2)
- Customer data
- Data encryption
- Security Groups and Network ACLs
- Application configurations

---

## 5. Why should the root user not be used daily?

The root user:

- Has unrestricted access to the AWS account.
- Cannot have permissions restricted.
- Is the primary target for attackers.

**Best Practice:** Use the root account only for tasks that require root privileges.

---

## 6. Why is MFA important for the root user?

Multi-Factor Authentication (MFA):

- Adds a second authentication factor.
- Protects against stolen passwords.
- Prevents unauthorized account access.

**Best Practice:** Always enable MFA on the root account.

---

## 7. What is the difference between an IAM User and an IAM Role?

### IAM User

- A permanent identity for a person or application.
- Has long-term credentials (password and/or access keys).
- Used for users who need ongoing access to an AWS account.
- Permissions are attached directly or through IAM groups.
- Can sign in to the AWS Management Console or access AWS using access keys.

### IAM Role

- An identity with a set of permissions that can be **assumed**.
- Does not have long-term credentials.
- Provides temporary security credentials through AWS STS.
- Can be assumed by IAM users, AWS services (such as EC2 or Lambda), or external identities.
- Commonly used for cross-account access, AWS service access, and federated authentication.

### Key Difference

- **IAM User** = Permanent identity with long-term credentials.
- **IAM Role** = Temporary identity that provides temporary credentials when assumed.

---

## 8. Why should permissions be attached to groups instead of individual users?

Using groups:

- Simplifies permission management.
- Keeps permissions consistent.
- Makes onboarding and offboarding easier.
- Reduces administrative overhead.

---

## 9. What is Least Privilege?

The **Principle of Least Privilege** means granting only the minimum permissions required to perform a task.

**Benefits:**

- Reduces security risks.
- Prevents accidental changes.
- Limits damage from compromised accounts.

---

## 10. What does an IAM policy contain?

An IAM policy is a JSON document containing:

- **Effect** (`Allow` or `Deny`)
- **Action** (AWS API operations)
- **Resource** (AWS resources)
- **Condition** (Optional restrictions)

Example:

```json
{
  "Effect": "Allow",
  "Action": "s3:GetObject",
  "Resource": "arn:aws:s3:::my-bucket/*"
}
```

---

## 11. What is the difference between a Managed Policy and an Inline Policy?

### Managed Policy

- Standalone policy.
- Reusable across multiple users, groups, and roles.
- Can be AWS-managed or customer-managed.
- Easier to maintain.

### Inline Policy

- Embedded directly into a single user, group, or role.
- Cannot be reused.
- Deleted automatically with the identity.

---

## 12. What does a Permission Boundary do?

A **Permission Boundary** defines the **maximum permissions** an IAM user or role can have.

Even if another policy grants additional permissions, actions outside the boundary are denied.

Think of it as a permission "ceiling."

---

## 13. Why are temporary credentials safer than long-lived access keys?

Temporary credentials are safer because they:

- **Expire automatically**, reducing the window of opportunity if they are compromised.
- **Reduce the impact of credential leaks**, since they become invalid after a short period.
- **Do not require manual rotation**, as new credentials are generated when needed.
- **Are issued by AWS Security Token Service (AWS STS)** after assuming an IAM role or through federated access.
- **Eliminate the need to store long-term access keys** in applications, CI/CD pipelines, or source code.

**Long-lived access keys:**

- Remain valid until they are manually rotated or deleted.
- Pose a higher security risk if exposed, as they can be misused for an extended period.
- Require regular rotation and secure storage as a security best practice.

**Key Difference:**  
Temporary credentials are short-lived and automatically expire, making them significantly more secure than long-lived access keys.

---

## 14. What problem does GitHub OIDC solve?

GitHub OpenID Connect (OIDC):

- Eliminates storing AWS access keys in GitHub Secrets.
- Allows GitHub Actions to securely request temporary AWS credentials.
- Improves security by using short-lived credentials.

---

## 15. What does AWS STS provide?

**AWS Security Token Service (STS)** provides temporary security credentials for AWS resources.

Common STS operations:

- `AssumeRole`
- `AssumeRoleWithWebIdentity`
- `GetSessionToken`
- `GetCallerIdentity`

**Benefits:**

- Temporary credentials
- Cross-account access
- Federated authentication
- Improved security
- No long-term access keys required

---