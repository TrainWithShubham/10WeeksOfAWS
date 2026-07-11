# Week 2 - IAM Roles, STS, and Temporary Credentials

AWS Zero To Hero - CloudAdhar x TrainWithShubham<br>
Session: Jul 11, 2026<br>
Course session: Day 3<br>
Exam focus: SAA-C03 Domain 1 - Design Secure Architectures<br>
Main pillar: Security

This session explains how AWS workloads access services without storing
long-lived access keys. The practical connects an EC2 instance to S3 through an
IAM role, an instance profile, and temporary credentials from AWS STS.

> This folder currently covers only the Jul 11 session. Jul 12 content will be
> added separately.

## Start Here

Complete the material in this order:

| Seq | Practice | File |
|---:|---|---|
| 01 | Learn roles, policies, STS, and instance profiles | [01-iam-roles-sts.md](./01-iam-roles-sts.md) |
| 02 | Build the EC2-to-S3 role practical | [02-ec2-s3-role-lab.md](./02-ec2-s3-role-lab.md) |
| 03 | Remove the resources created in the lab | [03-cleanup.md](./03-cleanup.md) |
| 04 | Submit your Day 3 work | [04-submission-format.md](./04-submission-format.md) |
| 05 | Post your learning update | [05-linkedin-post.md](./05-linkedin-post.md) |
| 06 | Revise and check your understanding | [06-quiz-prep.md](./06-quiz-prep.md) |

## What You Should Know

By the end of Jul 11:

- You can explain the difference between a trust policy and a permission
  policy.
- You can describe the `sts:AssumeRole` mechanism.
- You understand why an EC2 role is delivered through an instance profile.
- You can explain cross-service role assumption.
- You know what is included in temporary security credentials.
- You can attach an IAM role to EC2 and test allowed and denied S3 actions.

## Minimum Submission For Jul 11

Submit at least:

- One trust policy JSON file
- One least-privilege permission policy JSON file
- Screenshot of the role attached to the EC2 instance
- Proof that the allowed S3 read action worked
- Proof or a note that an S3 write action was denied
- One learning note and your LinkedIn post link

## Exam + Pillar Mapping

| Topic | Exam Mapping | Pillar | Best Practice |
|---|---|---|---|
| Trust policy | Domain 1 | Security | Restrict who can assume the role |
| Permission policy | Domain 1 | Security | Grant only required actions and resources |
| STS AssumeRole | Domain 1 | Security | Prefer temporary sessions |
| EC2 role | Domain 1 | Security | Do not store access keys on instances |
| Instance profile | Domain 1 | Security | Deliver role credentials to EC2 |
| Cross-service assumption | Domain 1 | Security | Use service principals intentionally |

## Safety Rules

- Do not create or copy IAM user access keys for this lab.
- Do not share access keys, secret keys, or session tokens.
- Use a test S3 bucket with no private or sensitive data.
- Keep the role and bucket permissions least privileged.
- Terminate the test instance and delete the test resources after the lab.

<div align="center">

[Week 1](../week-01/) | [Home](../README.md) | Week 2 - Jul 12 (coming later)

</div>
