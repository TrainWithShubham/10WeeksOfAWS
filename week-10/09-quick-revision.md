# Week 10 Quick Revision

## Recall

1. Synchronous Lambda callers wait for the function result; asynchronous callers receive acceptance first.
2. Event source mappings poll SQS, Kinesis, DynamoDB Streams, and Kafka; their retry behavior belongs to the source/mapping layer.
3. Concurrency is in-flight invocation count; estimate it as requests per second multiplied by average duration.
4. Reserved concurrency caps and reserves a function; provisioned concurrency reduces cold starts at extra cost.
5. VPC-connected Lambda does not receive a public IP merely because it uses a public subnet.
6. HTTP API is the lower-cost modern API choice when advanced REST features are unnecessary.
7. REST API is appropriate for API keys, usage plans, private REST APIs, caching, and broader controls.
8. WebSocket API is for persistent bidirectional communication.
9. Standard Step Functions provides durable execution history and supports long-running workflows.
10. Express Step Functions suits short, high-volume workflows with different history and delivery trade-offs.
11. Retry transient failures, not deterministic validation failures.
12. Catch states provide controlled recovery, compensation, notification, or terminal failure.
13. Lambda tasks must be idempotent because retries and duplicate delivery can occur.
14. CloudFormation parameters select deployment inputs; they do not create the referenced VPC or subnet.
15. Outputs expose values such as URLs, IDs, ARNs, and names after deployment.
16. A change set previews intended resource changes but does not guarantee execution success.
17. Drift means the deployed resource differs from the template's expected state.
18. Reconcile drift through reviewed template changes, not undocumented console edits.
19. `DeletionPolicy` controls deletion of a resource when removed or a stack is deleted.
20. `UpdateReplacePolicy` controls the old physical resource when an update requires replacement.
21. `Retain` can leave an S3 bucket or data resource behind after stack deletion.
22. CloudFormation is the infrastructure control plane, not the runtime order-processing data plane.

## Decision Table

| Requirement | Best direction |
|---|---|
| Low-cost Lambda-backed API | API Gateway HTTP API |
| API keys and usage plans | API Gateway REST API |
| Chat or live bidirectional updates | API Gateway WebSocket API |
| Durable order workflow | Step Functions Standard |
| Short high-volume workflow | Step Functions Express |
| Short event-driven code | Lambda |
| Private database access from Lambda | VPC attachment with private subnets and correct routes |
| Async Lambda failure record | SQS destination |
| Repeatable infrastructure | CloudFormation |
| Preview infrastructure update | Change set |
| Find manual configuration changes | Drift detection |
| Preserve important data on stack deletion | DeletionPolicy Retain |

## Important Traps

- Lambda async acceptance does not prove business success.
- SQS-triggered Lambda is an event source mapping, not Lambda's internal async queue.
- A Lambda destination record is richer than a simple original-event DLQ record.
- API Gateway CORS is not authentication.
- A Lambda public subnet does not provide a public IP or automatic internet access.
- Step Functions retry count is in addition to the initial attempt.
- Do not retry permanent validation failures.
- Express and Standard state machine types cannot be casually interchanged after creation.
- A CloudFormation parameter of type VPC or subnet selects an existing resource.
- A change set is a preview, not a guarantee.
- Drift detection reports differences; it does not automatically fix them.
- Retained S3 buckets continue to incur storage and must be emptied and deleted deliberately.
- CloudFormation rollback can leave failed resources or retained resources that require follow-up.
- IAM execution roles should use exact Lambda, DynamoDB, SQS, and Step Functions resources.

## Practice Questions

### Question 1

A Lambda function is invoked by API Gateway and the client must immediately receive the function result. Which invocation model applies?

A) Asynchronous invocation  
B) Synchronous invocation  
C) Event source mapping  
D) Dead-letter invocation

**Answer:** B. The API caller waits for the response and receives the function result or error directly.

### Question 2

A company needs API keys, usage plans, and response caching. Which API Gateway type is the best fit?

A) HTTP API  
B) REST API  
C) WebSocket API  
D) Lambda Function URL only

**Answer:** B. REST APIs provide these advanced API-management capabilities.

### Question 3

An order workflow requires durable history, retries, and a duration longer than five minutes. Which Step Functions type should be selected?

A) Express  
B) Standard  
C) WebSocket  
D) Event source mapping

**Answer:** B. Standard workflows provide durable history and support long-running orchestration.

### Question 4

A CloudFormation stack's SQS visibility timeout is changed manually in the console. What should happen next?

A) Delete the stack immediately  
B) Detect drift, investigate, and reconcile through a reviewed template change  
C) Ignore it because CloudFormation always overwrites it  
D) Replace the VPC

**Answer:** B. Manual changes create drift and should be brought back under controlled infrastructure-as-code management.

### Question 5

What does `DeletionPolicy: Retain` mean for an S3 bucket when the CloudFormation stack is deleted?

A) The bucket is always emptied and deleted  
B) The bucket is retained and may require manual cleanup  
C) The bucket is copied to another Region automatically  
D) The bucket becomes public

**Answer:** B. The resource remains and can continue to incur cost.

### Question 6

A Lambda function must access a private RDS database. Which design is appropriate?

A) Put Lambda in a public subnet and assume it gets a public IP  
B) Attach Lambda to private subnets and configure security groups and routes  
C) Add `0.0.0.0/0` to the database security group  
D) Disable IAM

**Answer:** B. VPC-connected Lambda needs correct private networking and least-privilege access.

### Question 7

A Step Functions task fails because a downstream service is temporarily throttling. What is the best response?

A) Retry with bounded exponential backoff  
B) Retry forever without delay  
C) Treat it as a permanent validation failure  
D) Delete the state machine

**Answer:** A. Transient failures are appropriate for bounded retries with backoff.

### Question 8

Which statement about a CloudFormation change set is correct?

A) It guarantees the update will succeed  
B) It previews proposed stack changes before execution  
C) It detects all runtime application errors  
D) It replaces all resources

**Answer:** B. A change set improves review but cannot guarantee execution success.
