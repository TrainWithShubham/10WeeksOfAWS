# Week 2 - Day 4: Organizations, Identity Center, and SCPs

## Name
Sanket Dangat

## Tasks Completed
- [x] Watched/read the weekly content
- [x] Completed hands-on labs
- [x] Added screenshots or proof
- [ ] Posted on LinkedIn
- [x] Cleaned up AWS resources

# Architecture Diagram

![Image](./diagrams/single-shared-aws-account.png)

![Image](./diagrams/aws-organizations-architecture.drawio.png)

![Image](./diagrams/permission-flow.drawio.png)

---

## Topics Practiced

- AWS Organizations account and Organizational Unit (OU) management
- AWS IAM Identity Center
- Service Control Policies (SCPs)
- AWS STS identity verification
- Amazon S3 access control using SCPs
- AWS Organizations consolidated billing

---

# What I Built

I implemented an AWS Organizations environment to demonstrate centralized governance using Service Control Policies (SCPs).

- Created an AWS Organization with Management and Member accounts.
- Configured the **Dev-Env** Organizational Unit (OU).
- Created and attached the **Deny-S3-Bucket-Creation** Service Control Policy (SCP) to the **Dev-Env** OU.
- Configured AWS IAM Identity Center and created the **CloudAdhar-Demo** user.
- Created the **CloudAdhar-Admin** permission set and assigned it to both the Management and Member accounts.
- Verified temporary credentials using **AWS STS** (`aws sts get-caller-identity`).
- Successfully created and deleted an Amazon S3 bucket before SCP enforcement.
- Moved the member account into the **Dev-Env** OU to inherit the attached SCP.
- Verified that Amazon S3 bucket creation was denied after SCP enforcement.
- Reviewed AWS Organizations consolidated billing.

---

# Part 1 – Review AWS Organization

Verified the AWS Organization structure, Organizational Unit, and attached Service Control Policy.

## AWS Organizations Overview

![AWS Organizations Overview](./screenshots/AWS-Organizations-Overview.png)

## Dev-Env SCP Attached

![Dev-Env SCP Attached](./screenshots/Dev-Env-SCP-Attached.png)

**Result**

- Verified the Management and Member accounts.
- Confirmed the Dev-Env Organizational Unit exists.
- Verified that the **Deny-S3-Bucket-Creation** SCP is attached to the Dev-Env OU.

---

# Part 2 – Verify IAM Identity Center Access

Logged in through AWS IAM Identity Center and verified temporary credentials.

## AWS Access Portal

![AWS Access Portal](./screenshots/AWS-Access-Portal.png)

## STS Caller Identity

![STS Caller Identity](./screenshots/STS-Get-Caller-Identity.png)

### Command

```bash
aws sts get-caller-identity
```

**Result**

- Successfully signed in through AWS IAM Identity Center.
- Verified access to both AWS accounts.
- Confirmed the active role was **AWSReservedSSO_CloudAdhar-Admin**.

---

# Part 3 – Test Before SCP Applies

Generated a unique bucket name and created an Amazon S3 bucket while the member account was directly under the Root of the organization.

### Commands

```bash
export AWS_REGION=ap-south-1

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

BUCKET="cloudadhar-before-scp-${ACCOUNT_ID}-$(date +%s)"

echo "$BUCKET"

aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region "$AWS_REGION" \
  --create-bucket-configuration LocationConstraint="$AWS_REGION"

aws s3api head-bucket --bucket "$BUCKET"
```

## S3 Bucket Created Before SCP

![S3 Bucket Created Before SCP](./screenshots/S3-Bucket-Created-Before-SCP.png)

Deleted the test bucket.

```bash
aws s3api delete-bucket --bucket "$BUCKET" --region "$AWS_REGION"

aws s3api head-bucket --bucket "$BUCKET"
```

## S3 Bucket Deleted

![S3 Bucket Deleted](./screenshots/S3-Bucket-Deleted.png)

**Result**

- Amazon S3 bucket creation succeeded.
- Bucket verification using `HeadBucket` succeeded.
- Bucket deletion completed successfully.
- `HeadBucket` returned **404 Not Found**, confirming successful deletion.

---

# Part 4 – Move Member Account into Dev-Env

Moved the **CloudAdhar-Dev** account from the Root into the **Dev-Env** Organizational Unit.

## Dev Account Moved To Dev-Env

![Dev Account Moved To Dev-Env](./screenshots/Dev-Account-Moved-To-Dev-Env.png)

**Result**

The member account now inherits the **Deny-S3-Bucket-Creation** Service Control Policy attached to the Dev-Env Organizational Unit.

---

# Part 5 – Test After SCP Applies

Verified the active identity and attempted to create another Amazon S3 bucket after the account inherited the SCP.

### Commands

```bash
aws sts get-caller-identity

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

BUCKET="cloudadhar-after-scp-${ACCOUNT_ID}-$(date +%s)"

echo "$BUCKET"

aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

## SCP Denies S3 Bucket Creation

![SCP Denies S3 Bucket Creation](./screenshots/SCP-Denies-S3-Bucket-Creation.png)

**Result**

The bucket creation request failed with:

- **AccessDenied**
- Explicit deny in a **Service Control Policy**
- `s3:CreateBucket` operation denied

This confirms that the Service Control Policy overrides IAM permissions granted through the **CloudAdhar-Admin** permission set.

---

# Part 6 – Review Consolidated Billing

The CloudAdhar-Management account uses AWS Cost Explorer to view consolidated billing across the AWS Organization.
The Linked account filter displays both management and member accounts for cost analysis.

## Organization Billing Overview

![Organization Billing Overview](./screenshots/Organization-Billing-Overview.png)

---

## What I Learned

- Understood how AWS Organizations simplifies multi-account management.
- Learned how Organizational Units (OUs) and Service Control Policies (SCPs) provide centralized governance.
- Configured AWS IAM Identity Center to provide secure, temporary access to multiple AWS accounts.
- Verified the active AWS identity using `aws sts get-caller-identity` before performing administrative tasks.
- Demonstrated that an explicit deny in an SCP overrides IAM permissions, even when using the `CloudAdhar-Admin` permission set.
- Reviewed how AWS Organizations supports consolidated billing across member accounts.

---

## Where I Got Stuck

**Issue:**
While creating the IAM Identity Center user, I initially entered the **member account email address** instead of using a separate email address for the Identity Center user. I mistakenly assumed that the AWS account email and the IAM Identity Center user email should be the same.

**Solved:**
I learned that **AWS account email addresses and IAM Identity Center user email addresses are independent**. I created the `CloudAdhar-Demo` user with a valid email address, assigned the `CloudAdhar-Admin` permission set to both AWS accounts, and successfully signed in through the AWS Access Portal.

---

## Cleanup

- Deleted the temporary Amazon S3 bucket created during testing.
- Deleted the AWS IAM Identity Center user and Permission Set.
- Removed the Service Control Policy (SCP) and Organizational Unit (OU).
- Removed the member account and deleted the AWS Organization.
- Verified that no unnecessary billable AWS resources remained.

---

## LinkedIn Post
Add your post link.