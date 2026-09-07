# Day 19 Practical - CloudFormation Security and Observability Stack

## What you will build

Use [cloudadhar-day19-security-observability-stack.yaml](./cloudadhar-day19-security-observability-stack.yaml) to deploy a classroom demonstration containing:

- an Auto Scaling web workload with Systems Manager access;
- CloudWatch logs, metrics, alarms, and an operations dashboard;
- a private encrypted and versioned S3 data bucket;
- CloudTrail management events and S3 object data events;
- EventBridge rules for S3, CloudFormation, Auto Scaling, GuardDuty, denied API calls, and high-value API activity;
- an SNS topic and Amazon Q Developer in chat applications Slack integration.

This lesson uses CloudFormation only. Use the supplied stack for both the metric and S3 activity tests.

## Slack integration

The AWS console may still display `AWS::Chatbot::SlackChannelConfiguration`; the product is now Amazon Q Developer in chat applications.

### Recommended: reuse an existing configuration

1. Create or open `#cloudadhar-aws-alerts` in the CloudAdhar Slack workspace.
2. Add Amazon Q Developer in chat applications and invite it to the channel.
3. In AWS, open **Amazon Q Developer in chat applications -> Configured clients -> Slack** and authorize the workspace. Authorization is account-specific.
4. Create or identify the SNS Standard topic `cloudadhar-day19-slack-alerts` and configure the channel to receive it.
5. Copy the SNS topic ARN and workspace ID.
6. Right-click the Slack channel, choose **Copy link**, and use only the final `C...` segment as `SlackChannelId`.

Deploy with:

```text
SlackIntegrationMode: UseExisting
ExistingAlertTopicArn: <existing SNS topic ARN>
CreateGuardDutyNotificationRule: No
```

Do not enter the channel name, complete Slack URL, or SNS ARN in `SlackChannelId`.

### CloudFormation-managed configuration

Use this only when the channel is not already configured for this AWS account and workspace:

```text
SlackIntegrationMode: CreateNew
CreateGuardDutyNotificationRule: Yes
SlackWorkspaceId: <authorized T... workspace ID>
SlackChannelId: <C... channel ID>
```

Do not create the SNS topic or configure the same channel manually first. CloudFormation creates the SNS topic, read-only channel role, Slack configuration, and event mappings. Configuring the same channel twice can fail deployment.

Send an Amazon Q test message after deployment. Slack threading is a presentation preference; a reply thread does not mean the event was lost.

## Deploy the stack

1. Use `ap-south-1` unless the instructor selects another Region.
2. Choose a VPC and public subnet with an Internet Gateway route.
3. Restrict `AllowedHttpCidr` to your own public IP where possible.
4. Use `t3.micro` for the classroom demonstration.
5. Set `Environment` to `demo` unless instructed otherwise.
6. Record stack outputs without publishing account IDs, ARNs, or secrets.

The EC2 security group exposes HTTP for the demonstration and does not open SSH. The two S3 buckets use `DeletionPolicy: Retain`, so review and remove retained buckets manually after the class.

## Test 1: custom metric and alarm

The stack creates `ApplicationFailuresAlarm`. Publish one datapoint with the exact stack environment dimension:

```bash
aws cloudwatch put-metric-data \
  --region ap-south-1 \
  --namespace CloudAdhar/Day19 \
  --metric-name ApplicationFailures \
  --dimensions Name=Environment,Value=demo \
  --unit Count \
  --value 1
```

Replace `demo` if needed. After the one-minute evaluation period, inspect the alarm and confirm the Slack notification. Wait for it to return to `OK` after the datapoint leaves the evaluation window.

## Test 2: S3 create, download, and delete

Read `DataBucketName` from the stack outputs:

```bash
printf 'day19 learner test\n' > /tmp/day19-test.txt
aws s3 cp /tmp/day19-test.txt s3://<DataBucketName>/class/day19-test.txt --region ap-south-1
aws s3 cp s3://<DataBucketName>/class/day19-test.txt /tmp/day19-download.txt --region ap-south-1
aws s3 rm s3://<DataBucketName>/class/day19-test.txt --region ap-south-1
```

- `Object Created` and `Object Deleted` are direct EventBridge events and should reach Slack quickly.
- `GetObject` is a CloudTrail S3 data event and may take longer to reach CloudWatch Logs and the audit notification.
- Data events can incur additional charges; enable them only for required resources.

Inspect the Operations dashboard, the CloudTrail log group, and the S3-related Slack messages. Delete test objects and old object versions before cleanup.

## Evidence checklist

Capture redacted evidence of:

- CloudFormation stack status and outputs;
- the CloudWatch dashboard and `ApplicationFailuresAlarm` state;
- the S3 create/delete notification;
- the CloudTrail `GetObject` event with sensitive identifiers hidden;
- the Amazon Q test message and one routed alert in Slack;
- Session Manager access without an inbound SSH rule.

Never publish account IDs, complete ARNs, OAuth secrets, credentials, real data, or public Slack links.

## Cleanup

1. Delete test objects and noncurrent versions from the data bucket.
2. Delete the CloudFormation stack.
3. Confirm the Auto Scaling group, EC2 instance, alarms, EventBridge rules, SNS topic, and Slack configuration are removed when CloudFormation owns them.
4. Manually review the retained data and CloudTrail audit buckets.
5. Remove temporary Cognito users and Google OAuth callback URLs if the identity demo was used.
