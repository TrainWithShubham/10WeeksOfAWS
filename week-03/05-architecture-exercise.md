# Week 3 Architecture Exercise

Create an editable draw.io diagram showing both the learner build and the
resilient production extension.

## Required Components

1. AWS Region boundary.
2. VPC `10.10.0.0/16`.
3. Two Availability Zone boundaries.
4. Public-A `10.10.1.0/24` and Private-A `10.10.11.0/24`.
5. Public-B `10.10.2.0/24` and Private-B `10.10.12.0/24`.
6. Internet Gateway attached to the VPC.
7. Public route table with `0.0.0.0/0 -> IGW`.
8. NAT-A in Public-A and NAT-B in Public-B.
9. Private-A default route to NAT-A.
10. Private-B default route to NAT-B.
11. S3 Gateway Endpoint connected through private route tables.
12. One Interface Endpoint ENI in a private subnet with a Security Group.
13. VPC Flow Logs publishing to CloudWatch Logs.
14. Security Groups around workload ENIs and NACLs around subnets.

## Route Labels

```text
Public-A/Public-B: 0.0.0.0/0 -> IGW
Private-A:          0.0.0.0/0 -> NAT-A
Private-B:          0.0.0.0/0 -> NAT-B
Private routes:     S3 prefix list -> S3 Gateway Endpoint
All route tables:   10.10.0.0/16 -> local
```

## Traffic Flows To Draw

- Public web request and response through IGW.
- Private-A outbound internet request through NAT-A and IGW.
- Private-A S3 request through the Gateway Endpoint without NAT.
- Private workload to Interface Endpoint ENI on TCP 443.
- Flow Log metadata from the monitored ENI or subnet to CloudWatch Logs.

## Decision Notes

Add these notes to the diagram:

- A public subnet is defined by its route to the IGW.
- A NAT Gateway must be in a public subnet for public IPv4 egress.
- Same-AZ private-to-NAT routing avoids an unnecessary cross-AZ dependency.
- SG is stateful; NACL is stateless.
- Peering is non-transitive; Transit Gateway is a transitive hub.
- Gateway Endpoint is the preferred private S3/DynamoDB path.

## Output

Save:

```text
diagrams/week-03-vpc-two-az.drawio
diagrams/week-03-vpc-two-az.png
```

Do not include real account IDs, resource IDs, public IP addresses, or internal
company network ranges in a public submission.
