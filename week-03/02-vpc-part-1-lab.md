# Day 5 Practical - Build a Two-AZ VPC

Goal: Build one custom VPC, four subnets, one Internet Gateway, and explicit
public and private route-table associations.

## Cost-Safe Boundary

Do not create EC2 instances or NAT Gateways in Part 1. Private subnets have no
outbound IPv4 internet path until Part 2.

## Prerequisites

- Use a dedicated learning account.
- Select Mumbai (`ap-south-1`) or the trainer-announced Region.
- Use two Availability Zones available in your own account.
- Run `aws sts get-caller-identity` before CLI operations.
- Optionally verify the CIDR plan with the
  [AWS Subnet Calculator](https://www.awssubnetcalculator.com/) after completing
  the subnet calculations manually.

## Part 1 - Create the VPC

1. Open VPC -> Your VPCs -> Create VPC.
2. Choose **VPC only**.
3. Name it `cloudadhar-day5-vpc`.
4. Use IPv4 CIDR `10.10.0.0/16`.
5. Use default tenancy and no IPv6 for the live lab.
6. Enable DNS resolution and DNS hostnames.

## Part 2 - Create Four Subnets

| Name | AZ | CIDR | Auto-assign public IPv4 |
|---|---|---|---|
| `cloudadhar-public-a` | First AZ | `10.10.1.0/24` | Enabled |
| `cloudadhar-private-a` | First AZ | `10.10.11.0/24` | Disabled |
| `cloudadhar-public-b` | Second AZ | `10.10.2.0/24` | Enabled |
| `cloudadhar-private-b` | Second AZ | `10.10.12.0/24` | Disabled |

Verify that every subnet is inside `10.10.0.0/16` and no ranges overlap.

## Part 3 - Create and Attach the IGW

1. Open Internet Gateways -> Create Internet Gateway.
2. Name it `cloudadhar-day5-igw`.
3. Attach it to `cloudadhar-day5-vpc`.

The IGW must be attached before it can be selected as a route target.

## Part 4 - Configure Route Tables

### Main route table

1. Filter route tables by the new VPC.
2. Find `Main = Yes`.
3. Name it `cloudadhar-main-rt-local-only`.
4. Keep only the automatic local route.

### Public route table

1. Create `cloudadhar-public-rt`.
2. Add `0.0.0.0/0 -> cloudadhar-day5-igw`.
3. Explicitly associate Public-A and Public-B.

### Private route table

1. Create `cloudadhar-private-rt`.
2. Keep only the local route.
3. Explicitly associate Private-A and Private-B.

## CLI Build Option

Use the Console or CLI path. Do not build duplicate resources with both.

```bash
export AWS_REGION="ap-south-1"
export VPC_NAME="cloudadhar-day5-vpc"
aws sts get-caller-identity

AZ1=$(aws ec2 describe-availability-zones \
  --region "$AWS_REGION" \
  --filters Name=state,Values=available \
  --query 'AvailabilityZones[0].ZoneName' --output text)
AZ2=$(aws ec2 describe-availability-zones \
  --region "$AWS_REGION" \
  --filters Name=state,Values=available \
  --query 'AvailabilityZones[1].ZoneName' --output text)

VPC_ID=$(aws ec2 create-vpc \
  --region "$AWS_REGION" --cidr-block 10.10.0.0/16 \
  --tag-specifications \
  "ResourceType=vpc,Tags=[{Key=Name,Value=$VPC_NAME},{Key=Project,Value=AWS-Zero-To-Hero-Week3}]" \
  --query 'Vpc.VpcId' --output text)

aws ec2 wait vpc-available --region "$AWS_REGION" --vpc-ids "$VPC_ID"
aws ec2 modify-vpc-attribute --region "$AWS_REGION" --vpc-id "$VPC_ID" \
  --enable-dns-support '{"Value":true}'
aws ec2 modify-vpc-attribute --region "$AWS_REGION" --vpc-id "$VPC_ID" \
  --enable-dns-hostnames '{"Value":true}'
```

Create subnets using the IP plan and tag names above. Then create and attach the
IGW, create the two custom route tables, add the public default route, and make
all four associations explicit.

## Validate

Use the VPC Resource Map and verify:

- Four subnets are distributed across two AZs.
- Public-A and Public-B auto-assign public IPv4.
- Private-A and Private-B do not.
- Public-A and Public-B use the public route table.
- The public route table has `0.0.0.0/0 -> IGW`.
- Private-A and Private-B use the local-only private route table.
- The main route table remains local-only as a safe fallback.
- The IGW is attached to the correct VPC.

Useful CLI validation:

```bash
aws ec2 describe-subnets --region "$AWS_REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'sort_by(Subnets,&CidrBlock)[].{Subnet:SubnetId,AZ:AvailabilityZone,CIDR:CidrBlock,AutoPublicIPv4:MapPublicIpOnLaunch,UsableNow:AvailableIpAddressCount}' \
  --output table

aws ec2 describe-route-tables --region "$AWS_REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" --output json
```

## Troubleshooting

- CIDR overlap: check that all subnets fit inside the VPC and do not intersect.
- IGW target unavailable: attach the IGW to the VPC first.
- Wrong subnet classification: inspect the subnet's actual route-table
  association.
- Wrong public IPv4 behavior: enable it only for the public subnets.
- `UnauthorizedOperation`: verify identity and permissions.

Keep this VPC for Day 6. If you will not continue, use
[06-cleanup.md](./06-cleanup.md).
