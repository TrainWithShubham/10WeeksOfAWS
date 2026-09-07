# Week 10 Submission Format

Document Day 18 serverless and CloudFormation work with sanitized evidence.

```text
week-10/submissions/<github-username>/
├── README.md
├── day18-serverless-order.png
├── day18-cloudformation-lifecycle.png
└── evidence/
    ├── lambda/
    ├── api-gateway/
    ├── step-functions/
    ├── cloudformation/
    └── cleanup/
```

## README Template

```markdown
# Week 10 - Serverless, Workflows, and Infrastructure as Code

## Learner
- Name:
- GitHub:
- LinkedIn:
- Region:

## Lambda
- Function name and runtime:
- Accepted invocation result:
- Business rejection result:
- Technical failure result:
- Invocation model comparison:
- Concurrency and cold-start lesson:
- VPC decision:

## Async Failure Handling
- SQS destination:
- Maximum event age and retry attempts:
- Destination record fields:
- Approximate invoke count:
- Destination versus DLQ explanation:

## API Gateway
- API type and reason:
- Route:
- Accepted request status:
- Rejected request status:
- Authentication, throttling, logging, and CORS decisions:

## Step Functions
- Workflow type and reason:
- Accepted path:
- Business rejection path:
- Technical failure retry and Catch path:
- Standard versus Express decision:
- Idempotency design:

## CloudFormation
- Stack name and parameters:
- Stack outputs:
- Change set preview:
- Update result and replacement behavior:
- Drift creation and detection:
- Drift reconciliation:
- DeletionPolicy and UpdateReplacePolicy explanation:

## Architecture Decision
Write 250-400 words.

## Cleanup
- APIs, state machines, Lambda functions, SQS:
- CloudFormation stack:
- Retained S3 bucket and versions:
- DynamoDB and PITR:
- EC2 and security group:
- IAM roles and policies:
- CloudWatch logs and alarms:
- Regions checked:

## Reflection
1. Who owns retries for synchronous, asynchronous, and event source mapping Lambda?
2. When is HTTP API better than REST API?
3. Why choose Standard rather than Express Step Functions for an order workflow?
4. Why is a Lambda public subnet not enough for internet access?
5. What does a change set show, and what can it not guarantee?
6. How does drift happen and how should it be reconciled?
7. What is the difference between DeletionPolicy and UpdateReplacePolicy?
8. Why must Lambda tasks be idempotent?
```

## Evidence Checklist

- [ ] Lambda accepted, rejected, and technical-failure tests
- [ ] Async retry and SQS destination record
- [ ] HTTP API route and sanitized curl results
- [ ] Standard Step Functions definition and three execution histories
- [ ] CloudFormation parameters, resources, outputs, and stack status
- [ ] Change set showing intended queue modification without replacement
- [ ] Drift detected and reconciled to `IN_SYNC`
- [ ] IAM policies scoped to exact resources
- [ ] Architecture diagrams
- [ ] Cleanup proof and billing review
