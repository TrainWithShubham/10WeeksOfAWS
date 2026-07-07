# Day 5 - Optional GitHub OIDC Challenge

This is optional. Try it only after the IAM user and group labs are done.

Here, GitHub Actions will access AWS without storing long-lived access keys.

## Architecture

`GitHub Actions -> OIDC token -> AWS IAM OIDC Provider -> AWS STS -> temporary credentials`

## Step 1 - Add OIDC Provider

Open: `AWS Console -> IAM -> Identity Providers -> Add Provider`

Use:

- Provider type: OpenID Connect
- Provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`

## Step 2 - Create IAM Role

Create a role with:

- Trusted entity: Web Identity
- Provider: `token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- Permission: `AmazonS3ReadOnlyAccess`

Example role name: `github-oidc-challenge-role`

## Step 3 - Trust Policy

Replace placeholders before using:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB_USER>/<REPOSITORY>:*"
        }
      }
    }
  ]
}
```

## Step 4 - Workflow

Create: `.github/workflows/aws-oidc-challenge.yml`

Use:

```yaml
name: AWS OIDC Challenge
on: workflow_dispatch
permissions:
  id-token: write
  contents: read
jobs:
  test-aws-oidc:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::<AWS_ACCOUNT_ID>:role/<ROLE_NAME>
          aws-region: ap-south-1
      - run: aws sts get-caller-identity
      - run: aws s3 ls
```

## Add These In Your Submission

- `oidc/trust-policy.json`
- `.github/workflows/aws-oidc-challenge.yml`
- Screenshot of OIDC provider
- Screenshot of IAM role
- Screenshot of successful GitHub Actions run
