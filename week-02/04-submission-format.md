# Week 2 - Jul 11 Submission Format

Create this folder in your fork:

```text
week-02/submissions/YOUR-NAME/day-3/
```

Suggested structure:

```text
week-02/submissions/your-name/day-3/
├── README.md
├── policies/
│   ├── ec2-trust-policy.json
│   └── s3-read-permission-policy.json
└── screenshots/
    ├── role-attached-to-ec2.png
    ├── assumed-role-identity.png
    ├── s3-read-allowed.png
    ├── s3-write-denied.png
    └── cleanup.png
```

## README Template

```markdown
# Week 2 - Day 3: IAM Roles and STS

## Name
Your Name

## Topics Practiced
- Trust policy vs permission policy
- STS AssumeRole
- EC2 role and instance profile
- Cross-service role assumption
- Temporary credentials
- Least-privilege S3 access

## What I Built
I attached an IAM role to EC2 and allowed it to read from one S3 bucket without
storing permanent access keys.

## Allowed Test
Write what succeeded.

## Denied Test
Write what failed with AccessDenied and why that was expected.

## What I Learned
Write the difference between a trust policy and permission policy in your own
words.

## Where I Got Stuck
Write one problem you faced, or write "No blocker".

## Cleanup
Write what you deleted after the lab.

## LinkedIn Post
Add your post link.
```

## Minimum Accepted Submission

- `README.md`
- Trust policy and permission policy JSON files
- One screenshot showing the role attached to EC2
- Proof of one allowed read and one denied write
- One learning note
- LinkedIn post link

## Screenshot Safety

Hide account IDs when possible. Never submit access keys, secret keys, session
tokens, SSH private keys, or sensitive object contents.
