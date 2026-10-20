# Week 1 Notes - IAM & AWS Security

## Topics Covered

- AWS Global Infrastructure
- Regions and Availability Zones
- Cache and Latency
- Compliance
- Disaster Recovery
- Shared Responsibility Model
- Root User
- IAM
- IAM Users
- IAM Groups
- IAM Policies
- IAM Roles
- Principle of Least Privilege
- Permission Boundary
- AWS Managed Policy
- Customer Managed Policy
- Billing Budget
- Zero Spend Budget

---

# Key Concepts

## Root User

- Created automatically when an AWS account is created.
- Has unrestricted access to all AWS services and resources.
- Should only be used for account-level administrative tasks.
- Enable MFA for better security.
- Do not use the Root User for daily work.

---

## IAM (Identity and Access Management)

IAM is an AWS service used to securely manage users, permissions, and access to AWS resources.

IAM helps answer three questions:

- Who can access AWS?
- What resources can they access?
- What actions can they perform?

---

## IAM User

- Represents an individual user.
- Used for daily AWS access.
- Has only the permissions assigned through IAM Policies.

---

## IAM Group

- Collection of IAM Users.
- Used to assign the same permissions to multiple users.
- Makes permission management easier.

Example:

Developers → Developer Group

---

## IAM Policy

A policy is a JSON document that defines permissions.

Policies determine:

- Allowed actions
- Denied actions
- Resources affected

Policies can be attached to:

- Users
- Groups
- Roles

---

## IAM Role

- Provides temporary permissions.
- Used by AWS services, applications, or users when needed.
- Does not have a permanent username or password.

Example:

EC2 → IAM Role → Access S3

---

## AWS Managed Policy

Policies created and maintained by AWS.

Example:

- AmazonS3ReadOnlyAccess
- AmazonEC2ReadOnlyAccess

---

## Customer Managed Policy

Policies created by the customer.

Useful when custom permissions are required.

Example:

Read access to only one S3 bucket.

---

## Principle of Least Privilege

Grant only the permissions required to perform a task.

Never grant unnecessary permissions.

---

## Permission Boundary

Defines the maximum permissions an IAM User or Role can have.

Even if another policy grants more permissions, the boundary cannot be exceeded.

---

## Shared Responsibility Model

AWS is responsible for:

- Physical data centers
- Hardware
- Networking
- Infrastructure

Customer is responsible for:

- IAM Users
- Passwords
- Applications
- Data
- Security Groups

---

## AWS Global Infrastructure

AWS Global Infrastructure consists of:

- Regions
- Availability Zones
- Edge Locations
- Regional Edge Caches
- Local Zones

---

## Regions

A geographical location containing multiple Availability Zones.

Example:

- Mumbai (ap-south-1)

---

## Availability Zones

One or more isolated data centers inside a Region.

Purpose:

- High Availability
- Fault Tolerance

---

## Cache

Frequently accessed data stored closer to users to reduce response time.

---

## Latency

Time taken for a request to travel from the user to the server and back.

Lower latency = Faster response.

---

## Compliance

Following legal and regulatory requirements.

Example:

Some organizations must keep customer data within a specific country.

---

## Disaster Recovery

Ability to recover applications and data after failures.

Examples:

- Multi-AZ Deployment
- Cross-Region Backup

---

# Important Observations

- AWS follows a **default deny** model.
- A user can perform only the actions explicitly allowed by IAM Policies.
- If no permission is granted, AWS automatically denies access.
- Testing with **AmazonEC2ReadOnlyAccess** confirmed that EC2 permissions do not automatically grant S3 access.
- The Principle of Least Privilege improves security by reducing unnecessary permissions.

---

# Interview Questions

### 1. What is IAM?

IAM (Identity and Access Management) is an AWS service used to securely manage users, permissions, and access to AWS resources.

---

### 2. What is the difference between Root User and IAM User?

**Root User**
- One per AWS account
- Full permissions
- Used rarely

**IAM User**
- Multiple users possible
- Limited permissions
- Used for daily work

---

### 3. What is an IAM Group?

A collection of IAM Users who require the same permissions.

---

### 4. What is an IAM Policy?

A JSON document that defines what actions are allowed or denied on AWS resources.

---

### 5. What is an IAM Role?

An identity with temporary permissions that can be assumed by AWS services, users, or applications.

---

### 6. What is the Principle of Least Privilege?

Grant only the minimum permissions required to perform a task.

---

### 7. What is a Permission Boundary?

A Permission Boundary defines the maximum permissions that an IAM User or Role can receive.

---

### 8. What is the Shared Responsibility Model?

AWS secures the cloud infrastructure, while customers secure their resources and data inside the cloud.

---

### 9. Why should we avoid using the Root User?

Because it has unrestricted permissions and increases security risk if used for daily activities.

---

### 10. What is the difference between AWS Managed Policies and Customer Managed Policies?

**AWS Managed Policies**
- Created and maintained by AWS.

**Customer Managed Policies**
- Created and maintained by the customer.
- Used for custom permission requirements.

---

### 11. What is an AWS Region?

A geographical location that contains multiple Availability Zones.

---

### 12. What is an Availability Zone?

One or more isolated data centers within a Region that provide high availability.

---

### 13. What is Latency?

The time taken for data to travel between the client and the server.

---

### 14. What is Cache?

A temporary storage that keeps frequently accessed data closer to users for faster access.

---

### 15. What is Disaster Recovery?

The process of restoring applications and data after a failure using backups or redundant infrastructure.

---

# Key Takeaways

- Always enable MFA for the Root User.
- Use IAM Users instead of the Root User for daily work.
- Follow the Principle of Least Privilege.
- AWS follows a default deny model.
- Test permissions to verify IAM Policies.
- Clean up AWS resources after completing labs to avoid unnecessary charges.