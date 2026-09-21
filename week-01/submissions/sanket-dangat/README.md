# Week 1 Submission - Sanket Dangat

## Name
Sanket Dangat

## Tasks Completed
- [x] Watched/read the weekly content
- [x] Completed hands-on labs
- [x] Added screenshots or proof
- [x] Posted on LinkedIn
- [x] Cleaned up AWS resources

## What I Built

- Secured my AWS account by enabling Root MFA and configuring Billing and Budget alerts.
- Created IAM users, groups, and roles following the principle of least privilege.
- Built and tested a custom S3 read-only IAM policy using JSON.
- Configured IAM Switch Role for temporary read-only access.
- Integrated GitHub Actions with AWS using OIDC authentication without storing long-lived AWS access keys.

## What I Learned

- Learned AWS security best practices, including enabling Root MFA and avoiding the use of the root user for daily tasks.
- Understood how IAM users, groups, roles, and policies help implement least-privilege access.
- Learned to create and apply custom IAM policies using JSON for fine-grained permissions.
- Gained hands-on experience with IAM Switch Role and temporary AWS credentials.
- Learned how GitHub Actions can securely access AWS using OIDC and AWS STS without storing long-lived access keys.


## LinkedIn Post
[LinkedIn Link](https://www.linkedin.com/posts/sanket-dangat-6462b8271_10weeksofaws-10weeksofaws-aws10weekchallenge-ugcPost-7480200964805910528-nu8H/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEJuHJYBII9imgLntyUMaz684Imwl2w4XOM)



## Topics Practiced
- AWS account security
- Root MFA
- Billing alert
- IAM users
- IAM groups
- IAM roles and OIDC-based temporary access
- IAM policies
- JSON policy
- Least privilege
- Permission boundaries
- GitHub OIDC role for AWS access
- GitHub OIDC with AWS


## Lab 1 — Secure Your AWS Account

Goal: Create a safe AWS account foundation for the next 10 weeks.

Steps:

1. Create or log in to your AWS account.
2. Enable MFA on the root user.
3. Open the Billing Dashboard.
4. Turn on billing alerts / budget alerts.
5. Create an alert for estimated charges, for example `$5`.
6. Stop using root user for daily activities.

**Before creating an AWS Billing Alarm, make sure these prerequisites are completed:**

1. Enable Billing Alerts
- Sign in as the AWS account root user (or an IAM identity with the necessary billing permissions if supported).
- Open the Billing and Cost Management console.
- Go to Billing preferences.
- Enable Receive CloudWatch billing alerts.
- Save the changes.

2. Use the North Virginia(us-east-1) AWS Region
- Billing metrics are available only in US East (N. Virginia) (us-east-1).
- Create the alarm in this region.

Deliverables:

### Root MFA enabled
![image](./screenshots/root-mfa.png)

### Billing Alert
![image](./screenshots/billing-alert.png)

### Budget Alerts
![image](./screenshots/budget.png)


## Where I Got Stuck

## Screenshot

![image](./screenshots/cloudwatch-billing-alerts-disabled.png)

**Issue:**
Initially, I couldn't create the Billing Alarm because CloudWatch billing alerts were not enabled and billing metrics were unavailable.

**Resolution:**

I enabled **Receive CloudWatch billing alerts** in **Billing Preferences**, selected the **US East (N. Virginia) (`us-east-1`)** region, and then successfully created the Billing Alarm.

![image](./screenshots/cloudwatch-billing-alerts-enabled.png)

- Why should the AWS root user not be used daily?
  - The root user has full access to the entire AWS account.
  - Using it every day is risky because one mistake can affect all resources.
  - If the root account is hacked, the attacker gets complete control of the AWS account.
  - For daily work, we should use IAM users or IAM roles with only the required permissions.
  - The root user should be used only for account setup and a few critical administrative tasks.
  - MFA should always be enabled on the root account for extra security.

- Why billing should be monitored from Day 1?
  - Helps avoid unexpected charges.
  - Keeps AWS spending under control.
  - Sends alerts when the budget limit is reached.
  - Helps use AWS resources wisely.
  - Makes it easier to stay within the Free Tier.
  
---

## Lab 2 — S3 Read-Only IAM Group and User

Goal: Understand IAM group-based access.

Create group:

```text
Group name: S3ReadOnlyGroup
Policy: AmazonS3ReadOnlyAccess
```

Create user:

```text
User name: learner-s3
Add user to: S3ReadOnlyGroup
```

Test:

1. Log in as `learner-s3`.
2. Open S3.
3. Confirm you can view/list S3 buckets.
4. Try an action that is not allowed.
5. Observe `Access Denied`.

Deliverables:

### Group created & Policy Attached
![image](./screenshots/iam-group-s3read-policy.png)

### User Added to group
![image](./screenshots/iam-learner-s3user-add-group.png)

### Allowed S3 view action
![image](./screenshots/s3-view-action.png)

### Denied Action
![image](./screenshots/s3-denied-action.png)


---

## Lab 3 — EC2 Read-Only Access

Goal: Apply least privilege to EC2.

Create group:

```text
Group name: EC2ReadOnlyGroup
Policy: AmazonEC2ReadOnlyAccess
```

Create user:

```text
User name: learner-ec2
Add user to: EC2ReadOnlyGroup
```

Test:

1. Log in as `learner-ec2`.
2. Open EC2 dashboard.
3. Confirm EC2 resources are visible.
4. Confirm the user cannot create or terminate instances.

Deliverables:

### EC2ReadOnlyGroup & Policy attached
![image](./screenshots/iam-group-ec2read-policy.png)

### User Added to group
![image](./screenshots/iam-learner-ec2user-add-group.png)

### EC2 Dashboard access
![image](./screenshots/ec2-dashboard-access.png)

### Denied Terminate action
![image](./screenshots/ec2-denied-terminate-action.png)

---

## Lab 4 — Billing View Access

Goal: Understand billing access with limited permissions.

Create group:

```text
Group name: BillingViewGroup
Policy: AWSBillingReadOnlyAccess
```

Create user:

```text
User name: learner-billing
Add user to: BillingViewGroup
```

Test:

1. Log in as `learner-billing`.
2. Open Billing Dashboard.
3. Verify billing visibility.
4. Confirm user cannot manage unrelated AWS services.
 

Deliverables:

### BillingViewGroup & Policy attached
![image](./screenshots/iam-group-billread-policy.png)

### Billing Dashboard access
![image](./screenshots/billing-dashboard-access.png)

### learner-billing user cannot manage unrelated AWS services
![image](./screenshots/billing-user-denied-action.png)

---

## Lab 5 — Custom S3 Read-Only JSON Policy

Goal: Read and create a basic JSON policy.

Create a customer managed policy:

```text
Policy name: CustomS3ReadOnlyTrainingPolicy
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
    }
  ]
}
```

Deliverables:

### Custom S3 Policy
[CustomS3ReadOnlyTrainingPolicy](policies/CustomS3ReadOnlyTrainingPolicy.json)

### Custom Policy Created
![image](./screenshots/custom-S3-read-only-training-policy.png)

### Policy Attached to learner-s3 user
![image](./screenshots/custom-s3-policy-attached-iam-user.png)

### Allowed action
![image](./screenshots/s3-custom-policy-allowed-action.png)
  - Successfully listed all S3 buckets
  - Successfully viewed objects in learner-s3-bucket-01.
  - Successfully downloaded AWS.xlsx 

### Denied action
![image](./screenshots/s3-custom-policy-denied-action.png)
  - Uploading a file (s3:PutObject) was denied due to insufficient permissions.
  - Deleting an object (s3:DeleteObject) was denied because the IAM policy does not allow this action

---

## Optional Advanced Lab — Switch Role

Goal: Understand role assumption and temporary access.

Create role:

```text
Role name: TrainingReadOnlyRole
Policy: ReadOnlyAccess
```

Create a policy for an IAM user that allows assuming this role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::ACCOUNT-ID:role/TrainingReadOnlyRole"
    }
  ]
}
```

Replace:

```text
ACCOUNT-ID
```

with your AWS account ID.

Test:

1. Log in as IAM user.
2. Use Switch Role in AWS Console.
3. Switch into `TrainingReadOnlyRole`.
4. Verify role-based access.


Deliverables:

### TrainingReadOnlyRole with ReadOnlyAccess
![image](./screenshots/trainingrole-readacess.png)

### IAM User Assume Role Policy Attached
![image](./screenshots/iam-user-assume-role-policy-attached.png)

### Login as IAM user(sanket)
![image](./screenshots/iam-user-sanket-login.png)

### Switch Role
![image](./screenshots/switch-role.png)

### Verify Role Access
![image](./screenshots/verify-role-access.png)

---

## Optional Advanced Challenge — GitHub OIDC with AWS

Goal: Configure secure GitHub Actions access to AWS without storing long-lived AWS access keys in GitHub Secrets.

This challenge helps you understand how GitHub Actions can authenticate to AWS using OIDC, IAM, and AWS STS.

### Architecture

```text
GitHub Actions
      │
      │ OIDC Token
      ▼
AWS IAM OIDC Provider
      │
      ▼
AWS STS AssumeRoleWithWebIdentity
      │
Temporary Credentials
      ▼
AWS Resources such as S3 or EC2
```

### Step 1 — Create GitHub OIDC Provider in AWS

Open:

```text
AWS Console → IAM → Identity Providers → Add Provider
```

Provider type:

```text
OpenID Connect
```

Provider URL:

```text
https://token.actions.githubusercontent.com
```

Audience:

```text
sts.amazonaws.com
```

Click **Add Provider**.

### Step 2 — Create IAM Role for GitHub Actions

Go to:

```text
IAM → Roles → Create Role
```

Select:

```text
Trusted entity: Web Identity
Identity Provider: token.actions.githubusercontent.com
Audience: sts.amazonaws.com
```

Use your own GitHub details:

```text
GitHub organization or username: <YOUR_GITHUB_ORG_OR_USERNAME>
GitHub repository: <YOUR_REPOSITORY_NAME>
```

Example:

```text
GitHub organization or username: your-github-username
GitHub repository: aws-week-1-challenge
```

Role name:

```text
<YOUR_OIDC_ROLE_NAME>
```

Example:

```text
github-oidc-challenge-role
```

Attach a safe challenge permission such as:

```text
AmazonS3ReadOnlyAccess
```

Create the role.

### Step 3 — Update the Trust Policy

Replace the role trust relationship with the policy below.

Replace the placeholders with your own values:

```text
<YOUR_AWS_ACCOUNT_ID> = your AWS account ID
<YOUR_GITHUB_ORG_OR_USERNAME> = your GitHub username or organization
<YOUR_REPOSITORY_NAME> = your repository name
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<YOUR_AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<YOUR_GITHUB_ORG_OR_USERNAME>/<YOUR_REPOSITORY_NAME>:*"
        }
      }
    }
  ]
}
```

Challenge note:

For stricter security, you can restrict the trust policy to a specific branch later, for example:

```text
repo:<YOUR_GITHUB_ORG_OR_USERNAME>/<YOUR_REPOSITORY_NAME>:ref:refs/heads/main
```

### Step 4 — Add GitHub Actions Workflow

Create this file in your repository:

```text
.github/workflows/aws-oidc-challenge.yml
```

Use this workflow:

```yaml
name: AWS OIDC Challenge

on:
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

jobs:
  aws-oidc-challenge:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Configure AWS Credentials using OIDC
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<YOUR_AWS_ACCOUNT_ID>:role/<YOUR_OIDC_ROLE_NAME>
          aws-region: ap-south-1

      - name: Verify AWS Identity
        run: aws sts get-caller-identity

      - name: Validate S3 Read Access
        run: aws s3 ls
```

Replace the placeholders with your own values:

```text
<YOUR_AWS_ACCOUNT_ID> = your AWS account ID
<YOUR_OIDC_ROLE_NAME> = your IAM role name created for this challenge
```

### Step 5 — Run the Challenge

1. Push the workflow to GitHub.
2. Open the repository in GitHub.
3. Go to **Actions**.
4. Select **AWS OIDC Challenge**.
5. Click **Run workflow**.
6. Open the workflow logs.
7. Check the output of `aws sts get-caller-identity`.

Expected output should show an assumed-role ARN similar to:

```text
arn:aws:sts::<YOUR_AWS_ACCOUNT_ID>:assumed-role/<YOUR_OIDC_ROLE_NAME>/...
```

If you see an assumed-role ARN, your GitHub OIDC challenge is completed successfully.

Deliverables:

### OIDC Provider
![image](./screenshots/OIDC-provider.png)

### IAM Role(github-oidc-challenge-role)
![image](./screenshots/github-oidc-challenge-role.png)

### OIDC Trust Policy
![image](./screenshots/oidc-trust-policy.png)

### Github Action Success
![image](./screenshots/gha-success.png)

### STS Assumed Role Output
![image](./screenshots/sts-assume-role-op.png)

### Validate S3 Read Access
![image](./screenshots/list-bucket.png)

### GHA workflow
[Workflow](oidc/aws-oidc-challenge.yml)

---

## Key Takeaway

- Least privilege is not just a setting — it is a mindset.
- Every IAM user, group, and role should have only the permissions required for their specific job, nothing more.
- Use IAM groups to manage policies centrally instead of attaching policies to individual users.
- Use IAM roles for temporary access instead of sharing long-lived credentials.
- Use OIDC for CI/CD pipelines to eliminate the need for storing AWS access keys in GitHub Secrets.
- This approach significantly reduces the AWS account attack surface.