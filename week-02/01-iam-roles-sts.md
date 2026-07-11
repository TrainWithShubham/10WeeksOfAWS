# Day 3 - IAM Roles, STS, and Temporary Credentials

Goal: Understand how an AWS service or workload gets temporary access to
another AWS service without storing permanent credentials.

## Before You Start

Write short answers in your own words:

1. Why should an application avoid storing access keys? -->
   ```
   Because if access keys are leaked, anyone can access AWS resources. Temporary credentials are much safer.
   ```
2. Who is allowed to assume a role? -->
   ```
   Only someone who is trusted.
   such as
   EC2
   Lambda
   Another IAM User
   Another AWS Account
   
   AWS checks the Trust Policy first
   ```
   
3. What is the role allowed to do after it is assumed? -->
   ```
   This is decided by the Permission Policy.
   The role may be allowed to

    Read S3
    Write CloudWatch Logs
    Read Secrets Manager
    or maybe only
    List S3 Bucket
   ```
   
4. Why do temporary credentials expire? -->
   ```
   becuase This improves security. it only work for a limited time. After it get expire, and become useless.
   ```

## IAM Role

An IAM role is an AWS identity with permissions, but it is not tied permanently
to one person. A trusted principal assumes the role and receives a temporary
session.

A principal can be:

- An AWS service such as EC2 or Lambda
- An IAM user or role in the same account
- A principal in another AWS account
- A federated identity

## Trust Policy vs Permission Policy

Both policies are needed, but they answer different questions.

| Policy | Main question | Typical content |
|---|---|---|
| Trust policy | Who can assume this role? | Principal and `sts:AssumeRole` |
| Permission policy | What can the assumed role do? | Allowed or denied actions and resources |

An EC2 trust policy looks like this:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

This policy trusts the EC2 service. It does not grant access to S3.

A separate permission policy grants the required S3 actions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject"],
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
    }
  ]
}
```

## STS AssumeRole Mechanism

AWS Security Token Service (STS) creates a temporary role session.

The simplified flow is:

1. A principal requests to assume a role.
2. AWS checks whether the role's trust policy trusts that principal.
3. AWS evaluates other applicable controls and permissions.
4. STS creates a temporary session for the role.
5. The workload uses the temporary credentials to call AWS APIs.
6. The credentials expire and are refreshed when required.

For a human or application making a direct STS request, the response contains:

- Access key ID
- Secret access key
- Session token
- Expiration time

The session token and expiration distinguish these credentials from traditional
long-lived IAM user access keys.

## Instance Profiles and EC2 Roles

An IAM role contains the trust relationship and permissions. An instance
profile is the container that makes one IAM role available to an EC2 instance.

When you create an EC2 role in the AWS console, AWS commonly creates and manages
the instance profile for you. Applications on the instance can use the standard
AWS credential provider chain. The AWS CLI and SDKs obtain and refresh the
temporary credentials automatically.

Do not place permanent access keys in:

- User data
- Environment files
- Application source code
- AMIs
- Shell history

## Cross-Service Role Assumption

Cross-service role assumption happens when one AWS service uses a role to call
another AWS service for you.

Examples:

- EC2 reads an object from S3.
- Lambda writes logs to CloudWatch Logs.
- Step Functions invokes a Lambda function.
- ECS tasks read secrets from Secrets Manager.

The role's trust policy names the calling service principal. Its permission
policy grants only the actions required on the target service.

## Key Line

> Trust policy answers WHO. Permission policy answers WHAT. STS supplies
> short-lived credentials. The instance profile delivers the role to EC2.

## Check Your Understanding

1. Does an EC2 trust policy grant permission to read an S3 object?
   ```
   no,A trust policy only decides whether EC2 can assume the role. S3 access must be granted by the permission policy
   ```
   
2. What must change if Lambda, rather than EC2, needs to assume the role?
   ```
   Update the trust policy to trust the Lambda service (lambda.amazonaws.com) instead of the EC2 service (ec2.amazonaws.com)
   ```
3. Why is an instance role safer than storing an IAM user's keys on EC2?
   ```
   Because the instance role uses temporary credentials that are automatically rotated and expire, reducing the risk if they're exposed
   ```
4. What should happen when temporary credentials expire?
   ```
   AWS automatically refreshes them (through the instance profile and AWS SDK/CLI), so applications can continue working without storing permanent access keys
   ```
