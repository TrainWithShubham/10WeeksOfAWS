# Week 2 - IAM Roles, STS, Organizations, and Identity Center

AWS Zero To Hero - CloudAdhar x TrainWithShubham<br>
Sessions: Jul 11-12, 2026<br>
Course sessions: Day 3-4<br>
Exam focus: SAA-C03 Domain 1 - Design Secure Architectures<br>
Main pillar: Security

Week 2 explains temporary access for workloads and centralized governance for
multiple AWS accounts. Day 3 connects EC2 to S3 through an IAM role and AWS STS.
Day 4 uses AWS Organizations, OUs, SCP guardrails, IAM Identity Center,
cross-account roles, and consolidated billing.

## Start Here

Complete the material in this order:

| Seq | Practice | File |
|---:|---|---|
| 01 | Learn roles, policies, STS, and instance profiles | [01-iam-roles-sts.md](./01-iam-roles-sts.md) |
| 02 | Build the EC2-to-S3 role practical | [02-ec2-s3-role-lab.md](./02-ec2-s3-role-lab.md) |
| 03 | Remove the resources created in the lab | [03-cleanup.md](./03-cleanup.md) |
| 04 | Submit your Day 3 work | [04-submission-format.md](./04-submission-format.md) |
| 05 | Post your learning update | [05-linkedin-post.md](./05-linkedin-post.md) |
| 06 | Revise Day 3 concepts | [06-quiz-prep.md](./06-quiz-prep.md) |
| 07 | Learn Organizations, SCPs, and Identity Center | [07-organizations-identity-center.md](./07-organizations-identity-center.md) |
| 08 | Build the Day 4 architecture diagram | [08-organizations-architecture.md](./08-organizations-architecture.md) |
| 09 | Run the before-and-after SCP practical | [09-organizations-scp-lab.md](./09-organizations-scp-lab.md) |

## What You Should Know

By the end of Week 2:

- You can explain the difference between a trust policy and a permission
  policy.
- You can describe the `sts:AssumeRole` mechanism.
- You understand why an EC2 role is delivered through an instance profile.
- You can explain cross-service role assumption.
- You know what is included in temporary security credentials.
- You can attach an IAM role to EC2 and test allowed and denied S3 actions.
- You can identify an organization Root, management account, member account,
  and organizational unit.
- You understand why an SCP is a guardrail and not a permission grant.
- You can explain permission sets and temporary AWSReservedSSO sessions.
- You can compare Identity Center and Organizations cross-account role
  patterns.
- You understand consolidated billing and linked-account cost visibility.

## Minimum Submission For Week 2

Submit at least:

- One trust policy JSON file
- One least-privilege permission policy JSON file
- Screenshot of the role attached to the EC2 instance
- Proof that the allowed S3 read action worked
- Proof or a note that an S3 write action was denied
- One learning note and your LinkedIn post link
- One masked organization tree screenshot
- One draw.io organization architecture diagram
- One masked Identity Center STS identity result
- Proof that S3 bucket creation worked before the SCP applied
- Proof that the SCP denied S3 bucket creation after the account move
- The `DenyS3BucketCreation` SCP JSON

## Exam + Pillar Mapping

| Topic | Exam Mapping | Pillar | Best Practice |
|---|---|---|---|
| Trust policy | Domain 1 | Security | Restrict who can assume the role |
| Permission policy | Domain 1 | Security | Grant only required actions and resources |
| STS AssumeRole | Domain 1 | Security | Prefer temporary sessions |
| EC2 role | Domain 1 | Security | Do not store access keys on instances |
| Instance profile | Domain 1 | Security | Deliver role credentials to EC2 |
| Cross-service assumption | Domain 1 | Security | Use service principals intentionally |
| AWS Organizations | Domain 1 | Security / Operations | Separate workloads by account |
| Organizational units | Domain 1 | Security / Operations | Group accounts by common controls |
| SCPs | Domain 1 | Security | Test guardrails on a dedicated OU |
| IAM Identity Center | Domain 1 | Security | Use groups, MFA, permission sets, and temporary sessions |
| Consolidated billing | Domain 4 | Cost Optimization | Review costs by linked account |

## Safety Rules

- Do not create or copy IAM user access keys for this lab.
- Do not share access keys, secret keys, or session tokens.
- Use a test S3 bucket with no private or sensitive data.
- Keep the role and bucket permissions least privileged.
- Terminate the test instance and delete the test resources after the lab.
- Mask account IDs, email addresses, portal URLs, organization IDs, and full
  role ARNs in screenshots.
- Test SCPs on a dedicated OU, not the organization Root.
- Never close a member account as normal lab cleanup.

<div align="center">

[Week 1](../week-01/) | [Home](../README.md)

</div>
