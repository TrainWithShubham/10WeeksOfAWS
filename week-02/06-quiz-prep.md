# Week 2 - Jul 11 Quiz Prep

Answer before checking the key.

## Questions

1. Which policy defines who may assume an IAM role?
2. Which policy defines what the assumed role may do?
3. What API action is central to assuming a role?
4. What four values describe an STS temporary credential set?
5. What connects an IAM role to an EC2 instance?
6. Why should an application on EC2 use the standard AWS SDK credential
   provider instead of storing keys?
7. An EC2 role has `s3:GetObject` but not `s3:PutObject`. Which operation should
   fail?
8. If a Lambda function needs to assume a service role, which service principal
   belongs in the trust policy?
9. Does a role's trust policy alone grant access to an S3 bucket?
10. What is the security benefit of short-lived credentials?

## Scenario Questions

### Scenario 1

An application on EC2 contains an IAM user's access key in a configuration
file. What should you recommend?

### Scenario 2

EC2 can assume a role, but S3 returns `AccessDenied` for `GetObject`. Name two
policy details to check.

### Scenario 3

An upload command succeeds even though the lab role does not allow
`s3:PutObject`. What should you inspect?

## Answer Key

1. The role's trust policy.
2. The role's permission policy.
3. `sts:AssumeRole`.
4. Access key ID, secret access key, session token, and expiration time.
5. An instance profile.
6. The SDK or CLI can obtain and refresh the role's temporary credentials
   automatically.
7. Uploading an object with `s3:PutObject` should fail.
8. `lambda.amazonaws.com`.
9. No. A permission policy must allow the required S3 actions and resources.
10. Exposure is time-limited, and the credentials are automatically rotated.

Scenario 1: Remove the stored keys, attach a least-privilege IAM role through an
instance profile, and let the SDK credential provider use temporary
credentials.

Scenario 2: Check that `s3:GetObject` is allowed and that the object ARN uses
`arn:aws:s3:::BUCKET-NAME/*`. Also consider applicable bucket policies, explicit
denies, and encryption key permissions.

Scenario 3: Check for broader attached or inline role policies and for AWS
environment variables or a CLI profile that may be supplying another identity.
