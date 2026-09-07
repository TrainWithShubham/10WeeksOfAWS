# Day 18 - Serverless and CloudFormation Foundations

## The CloudAdhar Order Story

A customer places an order through an HTTPS API. API Gateway receives the request,
Lambda validates it, Step Functions coordinates dependent work, and CloudFormation
creates the repeatable infrastructure.

```text
API Gateway = controlled front door
Lambda = focused event-driven compute
Step Functions = visible workflow coordination
CloudFormation = infrastructure lifecycle and source of truth
```

## AWS Lambda

Lambda runs short-lived event-driven code without managing servers. A function can
be invoked synchronously, asynchronously, or through an event source mapping.

| Invocation | Caller behavior | Retry ownership |
|---|---|---|
| Synchronous | Caller waits for result | Caller or integration |
| Asynchronous | Lambda accepts event and queues it internally | Lambda asynchronous service |
| Event source mapping | Lambda polls a source and invokes in batches | Source/mapping configuration |

Examples include API Gateway and Step Functions for synchronous calls; EventBridge,
SNS, and S3 for asynchronous events; and SQS, Kinesis, DynamoDB Streams, and Kafka
for event source mappings.

### Concurrency and cold starts

Concurrency is the number of in-flight invocations:

```text
Concurrency = requests per second x average duration in seconds
```

Reserved concurrency protects a function and caps it. Provisioned concurrency keeps
execution environments initialized at additional cost. Account quotas and event
source maximum concurrency protect downstream services. More memory also provides
more CPU, so measure rather than guessing.

Execution environments are reused when possible, but cold starts can occur at any
time. Reuse SDK clients outside the handler where safe, keep handlers idempotent,
and alarm on errors, throttles, duration, and concurrency.

### Async failures and destinations

Lambda asynchronous invocations can retry and then send a rich invocation record to
an SQS, SNS, Lambda, EventBridge, or S3 destination. A Lambda destination is not the
same as an SQS source queue DLQ: the destination contains invocation context and
supports success or failure routing, while a DLQ generally preserves the original
event.

### VPC access

Attach Lambda to a VPC only when it must reach private resources such as RDS,
ElastiCache, or internal services. Select private subnets across AZs, use a least-
privilege security group, provide NAT for required IPv4 internet egress, and use VPC
endpoints where appropriate. A public subnet does not give VPC-connected Lambda a
public IP or direct internet access.

## Amazon API Gateway

API Gateway manages API routes, stages, authorization, throttling, monitoring,
custom domains, and integrations. Lambda provides compute; API Gateway provides the
HTTP API contract.

| Requirement | Choice |
|---|---|
| Lower-cost modern REST endpoint and JWT authorizer | HTTP API |
| API keys, usage plans, response caching, advanced REST controls, private API | REST API |
| Persistent bidirectional connection | WebSocket API |

For the class, create an HTTP API with `POST /orders` integrated with the order
Lambda. Test accepted requests with HTTP 200 and business rejection with HTTP 400.
A browser request to the base URL sends `GET /`; `Not Found` is expected when only
`POST /orders` exists.

## AWS Step Functions

Step Functions makes workflow state visible and manages sequencing, retries, catches,
choices, waits, and controlled failure paths.

| Dimension | Standard | Express |
|---|---|---|
| Maximum duration | Up to 1 year | Up to 5 minutes |
| History | Durable execution history | CloudWatch Logs |
| Best fit | Orders, approvals, durable orchestration | High-volume short workflows |
| Pricing | State transitions | Duration and memory |
| Service integrations | Broad patterns including callback | Request-response focus |

A typical order workflow is:

```text
ValidateOrder Task
  -> Choice
      -> accepted: ProcessOrder -> NotifyOrder -> Succeed
      -> rejected: Fail
  -> technical error: Retry -> Catch -> Fail or compensation
```

Retry transient errors with bounded exponential backoff. Do not retry deterministic
validation failures. Make tasks idempotent before enabling retries.

## AWS CloudFormation

CloudFormation is the deployment and control plane, not the runtime order processor.
It describes desired infrastructure as a template and manages a stack lifecycle.

| Concept | Meaning |
|---|---|
| Parameter | Deployment-time input with validation |
| Resource | AWS object managed by the stack |
| Output | Exposed ARN, ID, URL, or name |
| Change set | Preview of proposed changes |
| Rollback | Return toward the last stable state after failure |
| Drift | Actual resource differs from template |
| DeletionPolicy | Resource behavior when stack/resource is deleted |
| UpdateReplacePolicy | Old physical resource behavior during replacement |

Use parameters for environment, VPC, subnet, instance type, AMI, and queue settings.
Use outputs for URLs, ARNs, IDs, and names. Keep IAM permissions least-privilege.

### Drift and retention

A manual console change can make a stack `DRIFTED`. Detect drift, investigate the
actual difference, and reconcile through a reviewed template update or change set.
`DeletionPolicy: Retain` preserves a resource after stack deletion, so retained S3
buckets and data must be reviewed and cleaned up deliberately.

## Service Selection Summary

| Need | Service |
|---|---|
| Short event-driven code | Lambda |
| Managed HTTP API surface | API Gateway |
| Durable visible workflow | Step Functions Standard |
| Very high-volume short workflow | Step Functions Express |
| Repeatable infrastructure | CloudFormation |
| Asynchronous failure record | Lambda destination to SQS |
| Key-value order state | DynamoDB |
| Traditional server in the demo | EC2 |
