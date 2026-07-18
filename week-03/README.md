# Week 3 - VPC Foundations, Security, NAT, and Endpoints

AWS Zero To Hero - CloudAdhar x TrainWithShubham<br>
Sessions: Jul 18-19, 2026<br>
Course sessions: Day 5-6<br>
Exam focus: SAA-C03 Domains 1-4<br>
Main pillars: Security and Reliability

Week 3 builds a two-Availability-Zone Amazon VPC and then adds controlled
private-subnet egress, network filtering, private AWS service access, scalable
VPC connectivity, and network observability.

Optional planning tool: [AWS Subnet Calculator](https://www.awssubnetcalculator.com/)
helps visualize VPC and subnet CIDR allocation. Calculate the ranges manually
first, then use the tool to verify your plan.

## Start Here

Complete the material in this order:

| Seq | Session | Practice | File |
|---:|---|---|---|
| 01 | Day 5 | Learn VPC, CIDR, subnets, and routing | [01-vpc-cidr-subnets-routing.md](./01-vpc-cidr-subnets-routing.md) |
| 02 | Day 5 | Build the two-AZ VPC | [02-vpc-part-1-lab.md](./02-vpc-part-1-lab.md) |
| 03 | Day 6 | Learn NAT, SGs, NACLs, endpoints, and connectivity | [03-vpc-security-and-connectivity.md](./03-vpc-security-and-connectivity.md) |
| 04 | Day 6 | Run the cost-safe Part 2 practical | [04-vpc-part-2-lab.md](./04-vpc-part-2-lab.md) |
| 05 | Both | Draw the final architecture | [05-architecture-exercise.md](./05-architecture-exercise.md) |
| 06 | End | Delete billable resources safely | [06-cleanup.md](./06-cleanup.md) |
| 07 | End | Submit Week 3 evidence | [07-submission-format.md](./07-submission-format.md) |
| 08 | Daily | Share learning progress | [08-linkedin-post.md](./08-linkedin-post.md) |
| 09 | Review | Revise the key decisions | [09-quick-revision.md](./09-quick-revision.md) |

## What You Should Know

By the end of Week 3:

- You can explain VPC, subnet, CIDR, route table, Internet Gateway, and local
  routes.
- You can calculate total and usable IPv4 addresses in an AWS subnet.
- You know that route-table behavior makes a subnet public or private.
- You can build four non-overlapping subnets across two Availability Zones.
- You can compare public IPv4, Elastic IP, IPv6, and egress-only IGW behavior.
- You can explain NAT Gateway versus NAT Instance and design NAT per AZ.
- You know why security groups are stateful and NACLs are stateless.
- You can choose between Gateway and Interface VPC Endpoints.
- You can compare VPC Peering with Transit Gateway.
- You can use VPC Flow Logs to investigate ACCEPT and REJECT traffic.

## Week 3 Architecture

```text
VPC 10.10.0.0/16
|
|-- AZ A
|   |-- Public-A  10.10.1.0/24  -> IGW
|   |   `-- NAT-A + public web test
|   `-- Private-A 10.10.11.0/24 -> NAT-A / S3 Gateway Endpoint
|
`-- AZ B
    |-- Public-B  10.10.2.0/24  -> IGW
    |   `-- NAT-B (production extension)
    `-- Private-B 10.10.12.0/24 -> NAT-B (production extension)
```

Part 1 creates the VPC, subnets, IGW, and route tables. Part 2 adds only NAT-A
for the short learner test. NAT-B is part of the resilient production design,
not the cost-safe classroom build.

## Minimum Submission

- VPC Resource Map screenshot
- CIDR plan and subnet address calculations
- Public and private route-table evidence
- Final two-AZ architecture diagram
- NAT Gateway versus NAT Instance comparison
- Security Group versus NACL comparison
- S3 Gateway Endpoint route-table evidence
- One masked Flow Logs `ACCEPT` record and one `REJECT` record
- Cleanup evidence and LinkedIn post link

## Exam and Pillar Mapping

| Topic | Exam Mapping | Pillar | Best Practice |
|---|---|---|---|
| Public/private segmentation | Domain 1 | Security | Minimize public exposure |
| Multi-AZ subnet design | Domain 2 | Reliability | Avoid one-AZ network foundations |
| CIDR and routing | Domain 3 | Performance | Plan scalable non-overlapping ranges |
| NAT and endpoints | Domains 3-4 | Performance / Cost | Use the correct egress or private path |
| SGs and NACLs | Domain 1 | Security | Apply layered least-privilege controls |
| Peering and Transit Gateway | Domains 2-3 | Reliability / Performance | Choose direct link or transitive hub intentionally |
| Flow Logs | Domains 1-2 | Security / Operations | Use metadata for troubleshooting |

## Cost and Safety Rules

- Use a dedicated learning AWS account and verify identity and Region first.
- Do not create NAT Gateway or EC2 during Part 1.
- NAT Gateway, Interface Endpoint, Elastic IP, public IPv4, EC2, and CloudWatch
  Logs can create charges.
- Delete the Interface Endpoint and NAT Gateway immediately after validation.
- Wait for NAT deletion before releasing its Elastic IP.
- Never expose SSH to `0.0.0.0/0`; use Session Manager where possible.
- Remove account IDs, resource IDs, IP addresses, and sensitive log data from
  public screenshots.

<div align="center">

[Week 2](../week-02/) | [Home](../README.md)

</div>
