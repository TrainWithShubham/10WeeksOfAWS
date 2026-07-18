# Week 3 Submission Format

Create this folder in your fork:

```text
week-03/submissions/YOUR-NAME/
```

Suggested structure:

```text
week-03/submissions/your-name/
├── README.md
├── cidr-plan.md
├── comparisons.md
├── commands/
│   ├── day-5-vpc-build.sh
│   └── day-6-networking.sh
├── diagrams/
│   ├── week-03-vpc-two-az.drawio
│   └── week-03-vpc-two-az.png
└── screenshots/
    ├── vpc-resource-map.png
    ├── public-route-table.png
    ├── private-route-table.png
    ├── nat-private-egress.png
    ├── nacl-deny-and-recovery.png
    ├── s3-endpoint-route.png
    ├── flow-log-accept-masked.png
    ├── flow-log-reject-masked.png
    └── cleanup.png
```

## README Template

```markdown
# Week 3 - Amazon VPC

## Name
Your Name

## Architecture
Explain the two-AZ VPC and add your diagram.

## CIDR Plan
List the VPC and four subnet CIDRs. Calculate total and usable addresses.

## Public vs Private
Complete: A subnet is public when...

## Day 5 Result
Explain the VPC, subnet, IGW, and route-table validation.

## Day 6 Result
Explain NAT egress, SG/NACL behavior, endpoints, and Flow Logs evidence.

## Architecture Decisions
- Why NAT per AZ?
- Why an S3 Gateway Endpoint?
- When would you use Transit Gateway instead of Peering?

## Where I Got Stuck
Write one problem and how you investigated it, or write "No blocker".

## Cleanup
List the resources you deleted.

## LinkedIn Posts
- Day 5: URL
- Day 6: URL
```

## Required Written Work

- CIDR table for all four `/24` subnets
- NAT Gateway versus NAT Instance comparison
- Security Group versus NACL comparison
- Gateway versus Interface Endpoint comparison
- VPC Peering versus Transit Gateway decision table
- One packet example explaining an ephemeral NACL return port

## Minimum Accepted Submission

- README and final architecture diagram
- VPC Resource Map
- Public and private route-table evidence
- S3 Gateway Endpoint route evidence
- One masked `ACCEPT` and one masked `REJECT` Flow Log record
- Written comparisons and cleanup note
- At least one LinkedIn post link

## Safety

Sanitize commands and screenshots. Hide account IDs, resource IDs, public IPs,
private company CIDRs, role ARNs, usernames, and sensitive Flow Log details.
Never submit credentials, private keys, or session tokens.
