# Week 01 Submission — Arun Rao

## Overview

This submission covers the Week 01 challenge for the 10 Weeks of AWS program. The tasks focus on setting up a secure AWS account foundation following AWS security best practices.

## Tasks Completed

### 1. Root Account MFA
- Enabled MFA on the AWS root user account
- Used a virtual MFA device (authenticator app)
- Screenshot: `screenshots/mfa_screenshot.png`

### 2. IAM User & Group Setup
- Created a dedicated IAM admin group with `AdministratorAccess` policy
- Created an IAM user (`arun-admin`) and added to the admin group
- Enabled console access with a strong password
- Screenshot: `screenshots/iam-user.png`, `screenshots/iam-group.png`

### 3. Billing Alerts
- Enabled billing alerts in account preferences
- Created a CloudWatch alarm to trigger when estimated charges exceed $5 USD
- Connected alarm to an SNS topic with email notification
- Screenshots: `screenshots/billing_alert.png`, `screenshots/billing-dash.png`

### 4. Custom S3 Read-Only Policy
- Created a custom IAM policy (`CustomS3ReadOnlyTrainingPolicy`) scoped to a specific bucket (`tests3tes`)
- Policy grants: `s3:ListAllMyBuckets`, `s3:ListBucket`, `s3:GetObject`
- Policy JSON: `code-or-policies/custom-s3-readonly-policy.json`
- Screenshot: `screenshots/s3-read-access.png`

### 5. EC2 Read-Only Access
- Verified that the IAM user has read-only access to EC2 (via `ReadOnlyAccess` policy)
- Confirmed write actions are denied
- Screenshot: `screenshots/ec2-read.png`

### 6. GitHub Actions OIDC Integration
- Registered GitHub Actions as an OIDC provider in IAM
- Created an IAM role with a trust policy scoped to the `Nurarao/aws-oidc-challenge` repo
- Attached the custom S3 read-only policy to the role
- Trust policy JSON: `oidc/trust-policy.json`
- Screenshots: `screenshots/oidc provider.png`

## File Structure

```
arun-rao/
├── README.md
├── notes.md
├── code-or-policies/
│   └── custom-s3-readonly-policy.json
├── oidc/
│   └── trust-policy.json
└── screenshots/
    ├── mfa_screenshot.png
    ├── billing_alert.png
    ├── billing-dash.png
    ├── billing_denied.png
    ├── ec2-read.png
    ├── oidc provider.png
    └── s3-read-access.png
```

## AWS Account Info

- Account ID: `268112656247`
- Region: `us-east-1`
- GitHub Repo for OIDC: `Nurarao/aws-oidc-challenge`
