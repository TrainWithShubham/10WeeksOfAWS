## Architecture Decisions Table

| **Requirement**                                        | **Choice**                                      | **Reason**                                                                                                                                                        |
| ------------------------------------------------------ | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Multiple independent subscribers to order events       | SNS Standard topic                              | Provides pub/sub fanout so one published order can be delivered independently to multiple subscribers.                                                            |
| Preserve message ordering within an order group        | SQS FIFO queue                                  | Guarantees ordered processing for messages sharing the same Message Group ID.                                                                                     |
| Failed messages that need investigation                | SQS DLQ with retention                          | Preserves repeatedly failed messages separately so they can be inspected and recovered without blocking the source queue.                                         |
| Filter messages by attribute without code changes      | SNS filter policy                               | Routes messages to subscriptions based on message attributes without requiring application-side filtering code.                                                   |
| Route based on order amount                            | EventBridge rule with numeric condition         | Matches events based on event content, such as an order amount greater than a defined threshold.                                                                  |
| Send payment reminder at specific time                 | EventBridge Scheduler one-time                  | Schedules a message for a specific time without requiring a continuously running scheduler or cron server.                                                        |
| Partition clickstream data by customer                 | Kinesis with customer-ID partition key          | Uses the customer ID as the partition key; Kinesis hashes the partition key to determine the shard, maintaining ordering for records with the same partition key. |
| Buffer and deliver clickstream to S3 for analytics     | Firehose with S3 destination                    | Provides managed buffering and delivery of streaming records to S3 without requiring custom delivery infrastructure.                                              |
| Batch storage with low cost                            | Firehose 5 MiB buffer and 300-second interval   | Buffers records before delivery to reduce the number of S3 objects and improve delivery efficiency.                                                               |
| Prevent duplicate messages within deduplication window | SQS FIFO with deduplication                     | FIFO deduplication helps prevent duplicate messages within the configured deduplication window while preserving order within a message group.                     |
| Scale to thousands of concurrent orders                | SQS Standard queue high throughput              | Standard SQS provides high throughput and automatically scales without requiring shard or partition management.                                                   |
| Near-real-time analytics on clickstream                | Kinesis on-demand capacity mode                 | Automatically handles changing ingestion traffic without requiring manual shard provisioning.                                                                     |
| Temporary retention of unprocessed orders              | SQS message retention 4 days                    | Retains unprocessed messages for the configured period so consumers have additional time to process or recover them.                                              |
| Event-driven integration without code coupling         | EventBridge versus direct SNS/SQS               | EventBridge provides content-based event routing and allows producers and consumers to remain loosely coupled.                                                    |
| Private S3 for analytics data                          | Block public access + encryption + partitioning | Prevents public access, protects stored data through encryption, and organizes delivered records using structured prefixes.                                       |

## Failure and Recovery Review

### 1. An SNS message cannot currently be delivered to the priority SQS subscription.

SNS attempts to deliver the message to the SQS subscription. If delivery is temporarily unsuccessful, SNS retries according to its configured delivery and retry behavior. The message remains available for delivery until the subscription delivery succeeds or the applicable retry policy is exhausted.

### 2. A message is received from SQS but the consumer crashes before deleting it.

The message remains invisible during the configured visibility timeout. If it is not deleted before the timeout expires, it becomes visible again and can be received by another consumer.

### 3. A FIFO message arrives without a message deduplication ID.

If content-based deduplication is disabled, the producer must provide a `MessageDeduplicationId`. Without it, the `SendMessage` request fails.

### 4. The EventBridge rule condition does not match an event.

The event is not matched by that rule, so EventBridge does not send the event to that rule's target.

### 5. An EventBridge Scheduler one-time task fails after the configured retry attempts.

After the configured retry attempts are exhausted, the invocation is considered failed. If a dead-letter queue is configured for the schedule, the failed event can be sent there for further investigation.

### 6. A Kinesis consumer is slow and records accumulate in the shard.

Records remain available in the shard until the consumer processes them or the stream retention period expires. The consumer can continue reading from its position and catch up with the accumulated records.

### 7. Firehose buffering is set to 5 MiB but only 2 MiB arrives; the interval is 300 seconds.

Firehose does not need to wait until 5 MiB is reached. When the 300-second buffering interval is reached, Firehose delivers the available buffered records to S3.

### 8. An SNS filter policy is updated while messages are in transit.

The updated filter policy affects message delivery based on the subscription's current filtering configuration. Messages that have already been delivered are not retroactively filtered.

### 9. A DLQ message is redriven to the source queue and fails again.

The message returns to the source queue and can be processed again. If it repeatedly fails and reaches the configured maximum receive count, it can be moved back to the DLQ.

### 10. The SQS queue visibility timeout is too short for processing time.

The message can become visible again before the first consumer finishes processing it. Another consumer may then receive the same message, potentially causing concurrent duplicate processing.

### 11. Multiple EventBridge rules target the same SQS queue with overlapping patterns.

An event can match multiple rules. Each matching rule can deliver the event to the same SQS target, potentially resulting in multiple messages in the queue.

### 12. Kinesis records arrive out of order from different shards.

Kinesis does not provide global ordering across different shards. Records with the same partition key are routed to the same shard, where their order is maintained.

### 13. An S3 prefix already exists with previous Firehose data.

Firehose can continue delivering objects using the existing S3 prefix. S3 prefixes do not need to be created in advance.

### 14. CloudShell runs out of time while waiting for Firehose to buffer and deliver.

The CloudShell session ending does not stop the AWS service. Firehose continues buffering and delivering records independently. The delivery result can be verified later in the S3 bucket.