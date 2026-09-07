# Week 10 - Serverless, Workflows, and Infrastructure as Code

AWS Zero To Hero - CloudAdhar x TrainWithShubham<br>
Session: September 6, 2026<br>
Course session: Day 19 (Sunday)<br>
Exam focus: SAA-C03 Domains 1-4<br>
Main pillars: Reliability, Security, Performance Efficiency, and Operational Excellence

Week 10 covers serverless application design, security governance, observability,
and repeatable infrastructure delivery.
Day 18 focuses on AWS Lambda, API Gateway, AWS Step Functions, and AWS CloudFormation.
Day 19 is the Sunday security, governance, and observability live class.
The optional end-to-end order application template connects API Gateway, Lambda, Step
Functions, DynamoDB, an EC2-hosted UI, and IAM roles.

## Start Here

| Seq | Session | Focus | File |
|---:|---|---|---|
| 01 | Day 18 | Serverless and CloudFormation foundations | [01-serverless-and-cloudformation-foundations.md](./01-serverless-and-cloudformation-foundations.md) |
| 02 | Day 18 | Live class practical placeholder | [02-serverless-and-cloudformation-practical.md](./02-serverless-and-cloudformation-practical.md) |
| 03 | Week 10 | Design an end-to-end serverless order application | [03-architecture-exercise.md](./03-architecture-exercise.md) |
| 04 | Day 19 | Security, governance, and observability foundations | [04-security-governance-and-observability.md](./04-security-governance-and-observability.md) |
| 05 | Day 19 | CloudFormation security and observability practical | [05-security-governance-and-observability-practical.md](./05-security-governance-and-observability-practical.md) |
| 06 | End | Remove Day 18 and Day 19 resources safely | [06-cleanup.md](./06-cleanup.md) |
| 07 | End | Submit Week 10 evidence | [07-submission-format.md](./07-submission-format.md) |
| 08 | Daily | Share learning progress | [08-linkedin-post.md](./08-linkedin-post.md) |
| 09 | Review | Revise Week 10 decisions and practice scenarios | [09-quick-revision.md](./09-quick-revision.md) |

Day 18 downloads:

- [End-to-end order application CloudFormation template](./cloudadhar-day18-CloudFormation.yaml)

## Day 18 Required Outcomes

- Distinguish synchronous, asynchronous, and event source mapping Lambda invocations.
- Explain Lambda concurrency, throttling, cold starts, retries, and destinations.
- Configure an asynchronous Lambda failure destination using SQS.
- Explain when Lambda needs VPC access and how subnets, routes, security groups,
  NAT gateways, and VPC endpoints affect the function.
- Select API Gateway HTTP, REST, or WebSocket APIs from requirements.
- Expose a Lambda order handler through an HTTP API `POST /orders` route.
- Orchestrate validation and order processing with a Standard Step Functions workflow.
- Use Task, Retry, Catch, Choice, Succeed, and Fail states correctly.
- Select Standard or Express Step Functions by duration, volume, history, and audit needs.
- Read CloudFormation parameters, resources, outputs, dependencies, and policies.
- Preview an update with a change set and explain rollback behavior.
- Detect and reconcile CloudFormation drift.
- Explain `DeletionPolicy` and `UpdateReplacePolicy` lifecycles.
- Describe the optional end-to-end template's EC2, API Gateway, Lambda, Step Functions,
  DynamoDB, IAM, and CloudWatch relationships.

## Architecture Overview

```text
Customer
  -> API Gateway HTTP API: POST /orders
  -> Order Lambda

Order Lambda / Step Functions
  -> ValidateOrder Lambda
  -> Choice: accepted or rejected
  -> ProcessOrder Lambda
  -> NotifyOrder Lambda
  -> DynamoDB orders table

Async Lambda failure
  -> Lambda internal retry
  -> SQS failure destination

CloudFormation template
  -> EC2-hosted UI
  -> API Gateway
  -> Lambda functions
  -> Standard Step Functions workflow
  -> DynamoDB table
  -> IAM roles and CloudWatch permissions
```

The live class teaches four related exercises. API Gateway and Step Functions are
not automatically one connected runtime path, and the Lambda asynchronous SQS
destination is not the same as an SQS-triggered Lambda event source mapping.

## Optional End-to-End Template

The supplied template creates an EC2-hosted order UI, API Gateway HTTP API, Lambda
functions, a Standard Step Functions workflow, a DynamoDB table, IAM roles, and
CloudWatch permissions. Treat the EC2 security group rule and public UI as temporary
classroom choices. Restrict HTTP to your own IP where possible and delete the stack
and retained data after collecting evidence.

## Cost and Safety

- Use the declared practice Region `us-east-1` unless the instructor changes it.
- Never expose account IDs, ARNs, credentials, customer data, or secrets in public evidence.
- Use least-privilege IAM policies and exact resource ARNs.
- Do not attach Lambda to a VPC unless private-resource access is required.
- Do not use `0.0.0.0/0` for database or administrative access.
- Public HTTP in the CloudFormation demo is temporary; use HTTPS and controlled ingress in production.
- EC2, NAT gateways, DynamoDB, API Gateway, Step Functions, Lambda, SQS, CloudWatch Logs,
  and retained S3 buckets can incur charges.
- Review `DeletionPolicy: Retain` resources manually; deleting a stack may not delete them.
- Tag resources with `Project = CloudAdhar-Day18` and an environment value.

## Exam + Pillar Mapping

| Topic | Exam Domain | Pillar | Best Practice |
|---|---|---|---|
| Lambda invocation models | Domain 3 | Reliability | Match retry ownership to invocation type |
| Lambda concurrency | Domain 3 | Performance | Protect downstream services with limits |
| API Gateway selection | Domain 3 | Security | Choose HTTP, REST, or WebSocket by feature need |
| Step Functions Standard | Domain 3 | Reliability | Make state, retries, and recovery visible |
| Step Functions Express | Domain 3 | Performance | Use for short, high-volume workflows |
| CloudFormation change sets | Domain 4 | Operational Excellence | Preview infrastructure mutations |
| CloudFormation drift | Domain 4 | Reliability | Keep deployed state aligned with code |
| IAM execution roles | Domain 1 | Security | Scope actions to exact resources |
| DynamoDB order storage | Domain 2 | Performance | Use managed, serverless storage for key-value access |
| Retention policies | Domain 2 | Reliability | Preserve important data deliberately |

<div align="center">

[Home](../README.md) | [Week 9](../week-09/) 

</div>
