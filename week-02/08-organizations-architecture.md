# Day 4 Exercise - Draw the Multi-Account Architecture

Create an editable diagram in draw.io before starting the console practical.

## Start With the Problem

Draw one large box named `ONE SHARED AWS ACCOUNT`. Put development, testing,
production, security, and finance inside it. Add these risks:

- Shared permissions
- Large blast radius
- Mixed billing
- Difficult governance

Then build the target multi-account architecture below.

## Target Architecture

```text
AWS ORGANIZATION
|
|-- ROOT
|   |-- CloudAdhar-Management
|   |   |-- Organizations administration
|   |   |-- IAM Identity Center administration
|   |   `-- Consolidated billing
|   |
|   `-- Dev-Env OU
|       |-- SCP: Deny S3 bucket creation
|       `-- CloudAdhar-Dev
|
`-- IAM Identity Center
    `-- cloudadhar-demo
        `-- CloudAdhar-Admin permission set
            `-- temporary STS session in CloudAdhar-Dev
```

## Draw.io Steps

1. Add an `AWS ORGANIZATION` container.
2. Add `ROOT` at the top of the hierarchy.
3. Add `CloudAdhar-Management` and label its three duties:
   Organizations administration, Identity Center administration, and
   consolidated billing.
4. Add the `Dev-Env` OU.
5. Initially keep `CloudAdhar-Dev` under Root and outside `Dev-Env`; this is the
   before-SCP state.
6. Attach an SCP label to the OU: `Deny S3 bucket creation`.
7. Add IAM Identity Center, user `cloudadhar-demo`, and permission set
   `CloudAdhar-Admin`.
8. Draw the temporary access path to the member account.
9. Draw one consolidated-billing arrow from the organization to the management
   account.
10. Add a second arrow showing `CloudAdhar-Dev` moving into `Dev-Env`; this is
    the after-SCP target state.

## Permission Flow Diagram

Add a second small diagram:

```text
Identity Center permission set: Allow s3:CreateBucket
                         +
Dev-Env SCP: Explicit deny s3:CreateBucket
                         =
Final result: Deny
```

## Submission

Save:

- `diagrams/aws-organizations-architecture.drawio`
- `diagrams/permission-flow.png`

Do not include real account IDs, email addresses, portal URLs, organization IDs,
or full role ARNs.
