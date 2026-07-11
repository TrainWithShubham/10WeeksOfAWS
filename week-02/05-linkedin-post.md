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
