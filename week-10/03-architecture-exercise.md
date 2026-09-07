# Week 10 Architecture Exercise

Design a production-oriented serverless order application using the Day 18 service
boundaries. Use the supplied order-application CloudFormation template as a learning
reference, then redraw the architecture with your own labels and decisions.

## Required Components

- Customer or client application
- API Gateway HTTP API with `POST /orders`
- Lambda order handler with validation and idempotency
- Standard Step Functions workflow
- Validate, process, and notify Lambda tasks
- Choice state for accepted versus rejected orders
- Retry and Catch path for transient technical failures
- DynamoDB table for order state
- Least-privilege Lambda and Step Functions IAM roles
- CloudWatch logs, metrics, alarms, and correlation identifiers
- SQS destination for asynchronous Lambda failures
- CloudFormation template, parameters, outputs, change sets, and drift controls
- Optional EC2-hosted UI only as a separate demonstration component

## Diagram

```text
Customer
   |
   v
API Gateway HTTP API: POST /orders
   |
   v
Submit / Order Lambda
   |\
   | \ synchronous workflow start
   |  v
   | Step Functions Standard
   |   -> ValidateOrder Lambda
   |   -> Choice: accepted or rejected
   |       -> ProcessOrder Lambda -> DynamoDB
   |       -> NotifyOrder Lambda -> Succeed
   |       -> Retry/Catch -> TechnicalFailure
   |
   \ asynchronous failure after Lambda retry
       -> SQS failure destination

CloudFormation template
   -> API, Lambda, Step Functions, DynamoDB, IAM, CloudWatch
```

## Decision Table

| Requirement | Choice | Reason | Trade-off |
|---|---|---|---|
| Modern low-cost HTTP API | HTTP API | Simpler and lower cost | Fewer advanced REST features |
| API keys and usage plans | REST API | Provides API management controls | More features and cost |
| Order orchestration with audit history | Step Functions Standard | Durable visible history | State-transition cost |
| Millions of short workflow executions | Step Functions Express | High-volume execution model | Short duration/history trade-offs |
| Short stateless validation code | Lambda | Managed event-driven compute | Runtime and concurrency limits |
| Private database access | Lambda in private subnets | Reaches private resources | ENI, route, NAT, and endpoint complexity |
| Order state by ID | DynamoDB | Managed low-latency key-value storage | Access patterns must be designed |
| Async Lambda failure record | SQS destination | Durable retry investigation path | Must monitor and redrive/process |
| Repeatable infrastructure | CloudFormation | Versioned desired state | Rollbacks and drift need operations |
| Important archive data | Retain policy | Prevent accidental deletion | Manual cleanup and cost responsibility |

## Failure Walkthrough

Explain what happens when:

1. API Gateway receives invalid JSON.
2. Lambda returns a business rejection.
3. Lambda throws a technical error synchronously.
4. An asynchronous Lambda invocation exhausts its retry attempts.
5. A Step Functions task fails transiently and is retried.
6. A deterministic validation error reaches a Choice or Fail state.
7. DynamoDB is unavailable during order processing.
8. Lambda concurrency throttles under a traffic burst.
9. A CloudFormation update requires resource replacement.
10. A manually changed queue is detected as drift.
11. Stack creation fails after some resources are created.
12. A retained S3 bucket remains after stack deletion.

## Architecture Explanation

Write 250-400 words covering API selection, Lambda invocation ownership, concurrency,
workflow retry and Catch behavior, DynamoDB access, IAM boundaries, CloudFormation
change sets, rollback, drift reconciliation, retention, observability, and cost.
Do not claim zero downtime or exactly-once business processing without explaining
idempotency and tested failure handling.

## Deliverables

- `day18-serverless-order.png`
- `day18-cloudformation-lifecycle.png`
- Decision table with completed reasons and trade-offs
- Failure walkthrough
- 250-400 word architecture explanation
- Sanitized practical evidence
- Cleanup proof
