# Week 10 Learn-in-Public Post

Write in your own voice and publish only sanitized evidence.

```text
Week 10, Day 18 of #10WeeksOfAWS

Today I studied serverless application design and infrastructure as code.

I learned how:
- API Gateway provides the HTTP API contract.
- Lambda runs focused event-driven code without server management.
- Step Functions makes order validation, retries, choices, and failure paths visible.
- CloudFormation turns infrastructure into a repeatable, reviewable deployment.

My practical evidence:
<Lambda invocation and async failure destination result>
<API Gateway POST /orders result>
<Step Functions accepted, rejected, and technical-failure execution paths>
<CloudFormation change set and drift reconciliation result>

My key design lesson:
<Explain retry ownership, idempotency, Standard versus Express, or drift control>

I removed the Day 18 APIs, functions, queues, workflows, stack resources, retained
objects, IAM roles, and other training resources after collecting sanitized evidence.

#AWS #AWSLambda #APIGateway #StepFunctions #CloudFormation #Serverless
#InfrastructureAsCode #CloudAdhar #TrainWithShubham
```

## Discussion Prompts

- Why is Lambda not a general-purpose always-running server?
- When does Step Functions add value beyond one Lambda function?
- Why should infrastructure changes go through templates and change sets?
- What did drift detection reveal?
- Which resource did you need to clean up manually because of retention behavior?
