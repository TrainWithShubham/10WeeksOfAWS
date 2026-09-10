# IAM Roles and AWS STS

## IAM Role

An IAM role is an AWS identity that contains permissions but does not have permanent credentials.

A trusted principal assumes the role and receives temporary security credentials to access AWS resources.

IAM roles are commonly used by:

* EC2 instances
* Lambda functions
* AWS services
* Applications
* External identities

---

# Trust Policy vs Permission Policy

An IAM role requires two different policies.

| Policy            | Purpose                                   | Answers                   |
| ----------------- | ----------------------------------------- | ------------------------- |
| Trust Policy      | Defines who can assume the role           | Who can access this role? |
| Permission Policy | Defines what actions the role can perform | What can this role do?    |

---

# Trust Policy

A trust policy defines the trusted principal that can assume an IAM role.

Example:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

This allows EC2 to assume the role.

A trust policy does not provide access to AWS resources.

---

# Permission Policy

A permission policy defines the AWS actions and resources available after the role is assumed.

Example:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListS3Bucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::ec2-s3-read-lab-sanket-dangat"
    },
    {
      "Sid": "AllowReadS3Objects",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::ec2-s3-read-lab-sanket-dangat/*"
    }
  ]
}
```

This grants permissions to access S3 resources.

---

# AWS STS AssumeRole

AWS Security Token Service (STS) provides temporary credentials when a principal assumes an IAM role.

The process:

1. A principal requests to assume a role.
2. AWS checks the trust policy.
3. AWS evaluates permissions.
4. STS creates a temporary role session.
5. Temporary credentials are provided.
6. Credentials expire after the session duration.

---

# Temporary Credentials

STS provides:

* Access key ID
* Secret access key
* Session token
* Expiration time

Temporary credentials are safer because they automatically expire.

---

# EC2 Roles and Instance Profiles

An EC2 instance receives an IAM role through an instance profile.

The relationship:

```
IAM Role
    |
Instance Profile
    |
EC2 Instance
```

The instance profile connects the IAM role to the EC2 instance.

EC2 applications can automatically obtain temporary credentials through:

* EC2 Instance Metadata Service (IMDS)
* AWS STS

AWS CLI and SDKs automatically refresh these credentials.

---

# Avoid Long-Term Access Keys

Do not store AWS access keys in:

* Source code
* Environment files
* User data scripts
* AMIs
* Shell history
* Public repositories

Use IAM Roles and temporary credentials instead.

---

# Cross-Service Role Assumption

Cross-service role assumption occurs when one AWS service uses an IAM role to access another AWS service.

Examples:

* EC2 accessing S3
* Lambda writing logs to CloudWatch
* ECS retrieving secrets from Secrets Manager
* Step Functions invoking Lambda

Requirements:

1. Trust policy allows the service to assume the role.
2. Permission policy allows required actions.

---

# Principle of Least Privilege

The principle of least privilege means providing only the permissions required for a specific task.

Example:

For an application that only reads from S3:

Allowed:

```
s3:ListBucket
s3:GetObject
```

Not required:

```
s3:PutObject
s3:DeleteObject
```

---

# Verification Commands

## Check Current Identity

```bash
aws sts get-caller-identity
```

Shows the current AWS identity being used.

---

## Check Credential Source

```bash
aws configure list
```

Shows where AWS credentials are coming from.

---

# Key Concepts

| Concept           | Meaning                             |
| ----------------- | ----------------------------------- |
| IAM Role          | Provides temporary AWS permissions  |
| Trust Policy      | Defines who can assume the role     |
| Permission Policy | Defines allowed actions             |
| AWS STS           | Provides temporary credentials      |
| Instance Profile  | Connects roles to EC2               |
| Least Privilege   | Grants minimum required permissions |

---

# Key Line

**Trust Policy answers WHO.**
**Permission Policy answers WHAT.**
**STS provides temporary credentials.**
**Instance Profiles deliver IAM roles to EC2.**

# Interview Questions and Answers

## Why should an application avoid storing access keys?

- Because long-term access keys can be stolen or leaked. Temporary credentials are more secure since they expire automatically.

---

## Who is allowed to assume a role?

- Only the principals that are listed in the role's trust policy, such as an AWS service, IAM user, IAM role, another AWS account, or a federated identity.

---

## What is the role allowed to do after it is assumed?

- It can perform only the actions allowed by the role's permission policy.

---

## Why do temporary credentials expire?

- They expire to reduce the risk of unauthorized access.

---

## Does an EC2 trust policy grant permission to read an S3 object?

- No. A trust policy only specifies who can assume the role. S3 access is granted by the permission policy.

---

## What must change if Lambda, rather than EC2, needs to assume the role?

- The trust policy must trust the Lambda service `lambda.amazonaws.com` instead of the EC2 service `ec2.amazonaws.com`.

---

## Why is an instance role safer than storing an IAM user's keys on EC2?

- Because EC2 receives temporary credentials through STS that are automatically rotated and expire, eliminating the need to store permanent access keys on the instance.

---

## What should happen when temporary credentials expire?

- Expired credentials should no longer work, and new temporary credentials must be obtained before making AWS API requests.