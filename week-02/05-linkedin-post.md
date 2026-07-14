# Week 2 - Jul 11 LinkedIn Plan

Share what you understood and tested in your own words. Do not copy the same
post as everyone else.

## What To Include

- The difference between a trust policy and a permission policy
- How STS provides temporary credentials
- Why an EC2 role is safer than storing access keys
- What your EC2 instance could read from S3
- Which write action was denied by least privilege
- One concept you still want to revise

## Simple Structure

```text
Day 3 of #10WeeksOfAWS

Today I learned how IAM roles and AWS STS give workloads temporary access.

Trust policy = who can assume the role.
Permission policy = what the role can do.

In the practical, my EC2 instance used an instance profile to read from one S3
bucket without stored access keys. The read worked, while the write was denied
as expected because the role followed least privilege.

My key takeaway: [write your takeaway here]
One topic I will revise: [write your topic here]
```

Rewrite the example in your own voice and add only safe screenshots.

## Tags

```text
@gangadhar ure @TrainWithShubham #10WeeksOfAWS #AWS10WeekChallenge #CloudAdhar #TrainWithShubham #AWS #IAM #STS
```

## Screenshot Safety

Do not show account IDs, access keys, secret keys, session tokens, private keys,
or sensitive S3 data.

## Jul 12 - Organizations and Identity Center

Write about:

- Why companies use multiple AWS accounts
- How OUs group accounts with common controls
- Why an SCP limits maximum permissions but does not grant access
- How IAM Identity Center provides temporary AWSReservedSSO sessions
- Your before-and-after S3 result when the member account moved into `Dev-Env`
- One benefit of consolidated billing

Suggested structure:

```text
Day 4 of #10WeeksOfAWS

Today I practiced centralized multi-account governance with AWS Organizations.
I verified an IAM Identity Center temporary session, then tested S3 bucket
creation before and after moving a member account into an SCP-controlled OU.

Before the move: [write your result]
After the move: [write your result]

My key takeaway: an SCP is a guardrail, not a permission grant.
```

Rewrite it in your own voice and use only masked screenshots.
