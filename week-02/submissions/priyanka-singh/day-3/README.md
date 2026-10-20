# Week 2 - Day 3: IAM Roles and STS

## Name
Priyanka Singh

## Topics Practiced
- Trust policy vs permission policy
- STS AssumeRole
- EC2 role and instance profile
- Cross-service role assumption
- Temporary credentials
- Least-privilege S3 access

## What I Built
I created an IAM role named `Week2Day3EC2S3ReadRole` and attached it to an Amazon Linux EC2 instance using an instance profile. I added an inline policy that allowed only `s3:ListBucket` and `s3:GetObject` permissions for a single S3 bucket. The EC2 instance accessed the bucket using temporary credentials provided by STS without storing any permanent access keys.

## Allowed Test
- Verified that no manually configured AWS credentials were present using `aws configure list`.
- Confirmed the EC2 instance was using an assumed IAM role with `aws sts get-caller-identity`.
- Successfully listed the S3 bucket using `aws s3 ls`.
- Successfully read the test object using `aws s3 cp`.

## Denied Test
Attempted to upload a test file to the S3 bucket using `aws s3 cp`, but received an `AccessDenied` error because the IAM role did not have the `s3:PutObject` permission. This was the expected behavior and confirmed that the least-privilege policy was working correctly.

## What I Learned
A trust policy defines **who is allowed to assume an IAM role**, while a permission policy defines **what actions the role is allowed to perform after it has been assumed**. In this lab, the trust policy allowed the EC2 service to assume the role, and the permission policy allowed the role to list and read objects from only one S3 bucket.

## Where I Got Stuck
Initially, I was unsure whether the inline policy should be attached to the S3 bucket or the IAM role. I also learned that `aws configure list` shows credentials with the source as `iam-role`, which indicates that temporary credentials are being automatically retrieved from the EC2 Instance Metadata Service (IMDS).

## Cleanup
After completing the lab, I:
- Terminated the EC2 instance.
- Deleted the IAM role and its inline policy.
- Deleted the S3 bucket and test object.
- Deleted the EC2 key pair.
- Verified that the EBS volume was automatically deleted.
- Deleted the unused security group created for the lab.

## LinkedIn Post
https://www.linkedin.com/posts/priyanka0ps_aws-iam-sts-ugcPost-7483915777071304704-__SK/?utm_source=share&utm_medium=member_android&rcm=ACoAAESVpAMB8D1gYyQIWgROJldV2hO5dTA3mTk