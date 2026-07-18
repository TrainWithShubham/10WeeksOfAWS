# Week 3 LinkedIn Plan

Write in your own voice. Share the architecture decision and the evidence, not
only a list of services.

## Day 5 - VPC Foundations

Write about:

- VPC and subnet scope
- Your CIDR plan across two Availability Zones
- What actually makes a subnet public
- The public and private route-table difference
- One IPv4 or IPv6 insight

Suggested structure:

```text
Day 5 of #10WeeksOfAWS

Today I manually built a two-AZ Amazon VPC with four non-overlapping subnets.

My most important takeaway: a subnet is public because its route table has a
route to an Internet Gateway, not because its name contains "public".

VPC CIDR: [write it]
Public route: [write it]
Private route in Part 1: [write it]

One concept I will revise: [your note]
```

## Day 6 - VPC Security and Private Access

Write about:

- The private EC2-to-NAT-to-IGW path
- Stateful Security Groups versus stateless NACLs
- Why S3 Gateway Endpoint can avoid the NAT path
- One `ACCEPT` or `REJECT` Flow Log insight
- Why a production design uses NAT per AZ

Suggested structure:

```text
Day 6 of #10WeeksOfAWS

Today I extended my VPC with private-subnet egress and layered controls.

NAT gives private IPv4 workloads outbound internet access. A VPC Endpoint gives
a private path to a supported service. They solve different problems.

My validation: [write what worked]
My troubleshooting evidence: [write what Flow Logs showed]
My cleanup: [list billable resources deleted]
```

## Tags

```text
@gangadhar ure @TrainWithShubham #10WeeksOfAWS #AWS10WeekChallenge #CloudAdhar #TrainWithShubham #AWS #AmazonVPC #CloudNetworking
```

## Screenshot Safety

Mask account IDs, resource IDs, public IP addresses, role ARNs, usernames, and
sensitive Flow Log fields. Never show credentials or session tokens.
