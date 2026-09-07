# Week 10 Cleanup

Capture sanitized evidence before deletion. Check Lambda, API Gateway, Step Functions,
CloudFormation, DynamoDB, SQS, EC2, IAM, and CloudWatch in `us-east-1` before declaring
cleanup complete.

## Preferred Order

1. Stop sending test events and confirm no Step Functions executions are running.
2. Delete or disable the API Gateway HTTP API `cloudadhar-orders-http-api-day18`.
3. Delete the Standard Step Functions state machine `cloudadhar-order-workflow-day18`.
4. Delete the Lambda asynchronous failure destination queue
   `cloudadhar-lambda-failure-day18` after inspecting or purging test records.
5. Delete the standalone Lambda `cloudadhar-order-handler-day18` and its lab-only
   execution role and inline destination policy.
6. If the CloudFormation stack was deployed, delete the stack only after capturing
   outputs, change-set, drift, and event evidence.
7. Before stack deletion, review the S3 archive bucket. Its `Retain` policy means
   the bucket may remain after the stack is deleted.
8. Empty and delete retained S3 buckets and all object versions/delete markers when
   they are no longer needed.
9. Confirm the CloudFormation-created DynamoDB table is deleted according to its
   policy; use Point-in-Time Recovery or backups only if deliberately retained.
10. Delete any optional EC2-hosted UI and its security group if it was created
    outside the stack.
11. Remove lab-only IAM roles, policies, CloudWatch log groups, alarms, and APIs only
    after confirming no other workload uses them.
12. Check the billing console and all Regions for resources accidentally created elsewhere.

## Optional Template Resources

The end-to-end template can create:

- EC2 instance and security group
- API Gateway HTTP API and routes
- Validate, process, notify, and submit Lambda functions
- Step Functions Standard state machine
- DynamoDB orders table with point-in-time recovery
- Lambda and Step Functions IAM roles
- CloudWatch log permissions and log groups

Delete the stack first so CloudFormation can remove dependencies. Then manually inspect
retained resources and any failed-cleanup resources shown in stack events.

## Final Checklist

- [ ] No running Step Functions executions remain
- [ ] API Gateway API deleted
- [ ] Step Functions state machine deleted
- [ ] SQS failure destination emptied and deleted
- [ ] Standalone Lambda and execution role deleted
- [ ] CloudFormation stack deleted successfully
- [ ] Retained S3 bucket emptied, including versions and delete markers, then deleted
- [ ] DynamoDB table and PITR status checked
- [ ] EC2 instance terminated
- [ ] Lab-only security groups removed
- [ ] Lab-only IAM roles and policies removed
- [ ] CloudWatch log groups and alarms reviewed
- [ ] No Day 18 resources remain in `us-east-1` or another accidentally used Region
- [ ] Billing and cost explorer checked

## Preserve Shared Resources

Do not delete shared VPCs, subnets, route tables, NAT gateways, IAM roles, KMS keys,
CloudWatch resources, or databases used by another week or workload.
