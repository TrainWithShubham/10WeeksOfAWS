# Day 6 Practical - NAT, NACL, Endpoints, and Flow Logs

Goal: Extend the Day 5 VPC using a short cost-safe build and validate each
network decision.

## Before You Start

- Confirm `cloudadhar-day5-vpc` still exists.
- Verify account and Region using `aws sts get-caller-identity`.
- Review [06-cleanup.md](./06-cleanup.md) before creating billable resources.
- Set a timer. NAT Gateway and Interface Endpoint are hourly billable.

## Part 1 - Create NAT-A

1. Open VPC -> NAT Gateways -> Create NAT Gateway.
2. Name it `cloudadhar-day6-nat-a`.
3. Select Public-A and public connectivity.
4. Allocate one Elastic IP.
5. Create the NAT Gateway and wait for `Available`.
6. Create `cloudadhar-private-a-rt` and associate Private-A.
7. Add `0.0.0.0/0 -> cloudadhar-day6-nat-a`.
8. Do not add a NAT route to Private-B in the learner lab.

Validate the complete path:

```text
Private EC2 -> Private-A route table -> NAT-A in Public-A
            -> Public route table -> IGW -> internet
```

## Part 2 - Validate a Private EC2 Instance

1. Launch a small Amazon Linux 2023 instance in Private-A.
2. Disable public IPv4 assignment.
3. Attach a role that supports Session Manager and required read-only commands.
4. Use a Security Group with no inbound rule and required outbound access.
5. Connect through Session Manager after NAT-A is available.
6. Run:

```bash
curl -I https://aws.amazon.com
aws sts get-caller-identity
```

The instance has outbound access but no public IPv4 and accepts no direct
inbound internet connection.

Production extension: deploy NAT-B in Public-B, create a separate Private-B
route table, and route Private-B to NAT-B. Do not route both AZs through NAT-A
in the final resilient design.

## Part 3 - Compare SG and NACL Behavior

1. Launch a small web EC2 instance in Public-A with nginx or httpd user data.
2. Create a Security Group allowing HTTP 80 for the demo.
3. If SSH is used, restrict it to your IP; prefer Session Manager.
4. Confirm the web page works.
5. Create a custom NACL for Public-A.
6. Add inbound HTTP plus required return rules.
7. Add outbound HTTP/HTTPS plus ephemeral return rules.
8. Associate the custom NACL with Public-A.
9. Add a lower-numbered deny for TCP 80 from your public IP `/32`.
10. Confirm failure, remove the temporary deny, and confirm recovery.

Rule 90 is evaluated before rule 100. A NACL stops at the first matching rule.

## Part 4 - Create an S3 Gateway Endpoint

1. Open VPC -> Endpoints -> Create Endpoint.
2. Select AWS services and the regional S3 **Gateway** endpoint.
3. Select `cloudadhar-day5-vpc`.
4. Select `cloudadhar-private-a-rt`.
5. Use Full Access for the initial connectivity test, then review a scoped
   endpoint policy.
6. Inspect the new S3 prefix-list route.
7. From the private EC2 instance, run:

```bash
aws s3api list-buckets
```

IAM must still allow the S3 action. The endpoint supplies a private path, not
permission.

## Part 5 - Create a Short-Lived Interface Endpoint

1. Create an Interface Endpoint for a supported API such as EC2.
2. Select Private-A only for the cost-safe lab.
3. Enable private DNS.
4. Attach an endpoint Security Group allowing TCP 443 from the private
   instance's Security Group.
5. Inspect the endpoint ENI and DNS names.
6. Run:

```bash
nslookup ec2.ap-south-1.amazonaws.com
```

7. Delete the Interface Endpoint immediately after validation.

## Part 6 - Enable Flow Logs

1. Select the VPC -> Flow Logs -> Create Flow Log.
2. Choose traffic type **All**.
3. Send records to a dedicated CloudWatch Logs group.
4. Create or select the required delivery IAM role.
5. Generate successful web traffic.
6. Repeat the temporary NACL deny to generate rejected traffic.
7. Run the REJECT query from
   [03-vpc-security-and-connectivity.md](./03-vpc-security-and-connectivity.md).
8. Identify interface, source, destination, ports, protocol, and action.

## CLI Starter

```bash
export REGION=ap-south-1
aws sts get-caller-identity

VPC_ID=$(aws ec2 describe-vpcs --region "$REGION" \
  --filters "Name=tag:Name,Values=cloudadhar-day5-vpc" \
  --query 'Vpcs[0].VpcId' --output text)

PUBLIC_A_SUBNET_ID=$(aws ec2 describe-subnets --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  "Name=tag:Name,Values=cloudadhar-public-a" \
  --query 'Subnets[0].SubnetId' --output text)

PRIVATE_A_SUBNET_ID=$(aws ec2 describe-subnets --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  "Name=tag:Name,Values=cloudadhar-private-a" \
  --query 'Subnets[0].SubnetId' --output text)

EIP_ALLOC_ID=$(aws ec2 allocate-address --region "$REGION" \
  --domain vpc --query 'AllocationId' --output text)

NAT_A_ID=$(aws ec2 create-nat-gateway --region "$REGION" \
  --subnet-id "$PUBLIC_A_SUBNET_ID" --allocation-id "$EIP_ALLOC_ID" \
  --tag-specifications \
  'ResourceType=natgateway,Tags=[{Key=Name,Value=cloudadhar-day6-nat-a}]' \
  --query 'NatGateway.NatGatewayId' --output text)

aws ec2 wait nat-gateway-available --region "$REGION" \
  --nat-gateway-ids "$NAT_A_ID"
```

## Validation Checklist

- Private-A has its intended route-table association.
- NAT-A is available and Public-A has an IGW route.
- Private EC2 has no public IPv4 and can initiate outbound access.
- SG and NACL rules allow the intended flow and return traffic.
- The temporary lower-numbered NACL deny blocks HTTP.
- S3 Gateway Endpoint adds a prefix-list route.
- Interface Endpoint uses a private ENI, private DNS, and restrictive SG.
- Flow Logs show expected `ACCEPT` and `REJECT` records.

Complete [06-cleanup.md](./06-cleanup.md) immediately.
