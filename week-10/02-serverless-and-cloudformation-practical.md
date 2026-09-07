# Day 18 Practical

## Status

The instructor reference and CloudFormation template are included in Week 10. The
exact hands-on steps for today's class will be added after the live practice is
completed.

## Planned Practical Scope

The final practical should document the following exercises from the Day 18 guide:

1. Create and test `cloudadhar-order-handler-day18` with accepted, rejected, and
   deliberate technical-failure events.
2. Configure asynchronous Lambda retries and the SQS failure destination
   `cloudadhar-lambda-failure-day18`.
3. Create an HTTP API `POST /orders` route and test HTTP 200 and HTTP 400 behavior.
4. Create a Standard Step Functions order workflow with Task, Retry, Catch, Choice,
   Succeed, and Fail states.
5. Execute accepted, business-rejection, and technical-failure workflow paths.
6. Create `cloudadhar-infrastructure-day18` from the CloudFormation lifecycle template.
7. Review stack outputs, create and execute a visibility-timeout change set, and
   verify the update without replacement.
8. Create safe SQS drift, detect it, reconcile it, and confirm `IN_SYNC`.
9. Explain deletion and replacement behavior for the retained S3 archive bucket.
10. Review and deploy the optional end-to-end order application template only when
    its parameter and security requirements are understood.

## Practical Evidence Placeholder

Add the completed class evidence here:

- Lambda function configuration and three invocation results:
- Async retry count and SQS destination record:
- API Gateway route, invoke URL, and curl results:
- Step Functions definition and execution histories:
- CloudFormation stack events and outputs:
- Change set preview and execution result:
- Drift detection and reconciliation result:
- Cleanup screenshots and billing/resource verification:
- Troubleshooting notes:

> Do not record account IDs, secret values, credentials, customer data, private
> endpoints, or unrestricted public access in shared evidence.
