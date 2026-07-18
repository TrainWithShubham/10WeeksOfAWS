# Week 3 Cleanup

Cleanup order matters because resources have dependencies and some are
billable by time.

## Delete First

The two most urgent resources are:

1. Interface Endpoint
2. NAT Gateway

Delete NAT Gateway, wait until it is deleted, then release its Elastic IP.

## Day 6 Cleanup Order

1. Terminate the Day 6 EC2 instances.
2. Delete the Interface Endpoint.
3. Delete NAT-A and wait for deletion.
4. Release the Elastic IP.
5. Delete the S3 Gateway Endpoint if not needed.
6. Delete the VPC Flow Log.
7. Delete the dedicated CloudWatch log group if not needed.
8. Restore the original NACL association.
9. Delete the custom NACL.
10. Remove temporary route tables and Security Groups.

Core NAT and endpoint commands:

```bash
aws ec2 delete-vpc-endpoints --region "$REGION" \
  --vpc-endpoint-ids "$EC2_ENDPOINT_ID" "$S3_ENDPOINT_ID"

aws ec2 delete-nat-gateway --region "$REGION" \
  --nat-gateway-id "$NAT_A_ID"

aws ec2 wait nat-gateway-deleted --region "$REGION" \
  --nat-gateway-ids "$NAT_A_ID"

aws ec2 release-address --region "$REGION" \
  --allocation-id "$EIP_ALLOC_ID"
```

Run commands only for variables that contain verified lab resource IDs. If a
variable is empty or uncertain, use the Console and confirm the resource name.

## Delete the Day 5 VPC

Keep the base VPC only if the trainer confirms it will be reused. Otherwise:

1. Confirm all EC2 instances, endpoints, and NAT Gateways are gone.
2. Disassociate custom route-table associations.
3. Delete the four subnets.
4. Delete the public and private custom route tables.
5. Detach the Internet Gateway from the VPC.
6. Delete the Internet Gateway.
7. Delete the VPC.

The main route table and default VPC components managed with the VPC disappear
with the VPC. Do not delete unrelated or default-account networking resources.

## Final Cost Check

- No Week 3 EC2 instance is running.
- No NAT Gateway remains in `Pending`, `Available`, or `Deleting` longer than
  expected.
- No allocated Elastic IP remains.
- No Interface Endpoint remains.
- No unexpected public IPv4 address remains.
- No unnecessary CloudWatch log group continues retaining lab data.
- No Week 3 resource remains in another Region.

Add safe cleanup evidence to your submission.
