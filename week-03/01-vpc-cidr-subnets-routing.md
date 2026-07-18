# Day 5 - VPC, CIDR, Subnets, and Routing

Goal: Understand the network building blocks before creating resources.

## Core Story

> A VPC is your regional network boundary. A subnet is an AZ-specific portion
> of that address space. A route table decides where traffic goes. An Internet
> Gateway provides an internet route.

## Key Concepts

| Concept | Meaning |
|---|---|
| VPC | A logically isolated virtual network in one AWS Region |
| Subnet | A VPC CIDR range that belongs to one Availability Zone |
| CIDR | Address range plus network prefix, such as `10.10.0.0/16` |
| Route table | Destination-and-target rules that select a traffic path |
| Local route | Automatic route for communication inside the VPC CIDR |
| Internet Gateway | Highly available VPC gateway targeted by internet routes |
| Main route table | Fallback route table for subnets without explicit association |
| Elastic IP | Static public IPv4 allocated to the account and reassociable |
| Egress-only IGW | Outbound-initiated IPv6 path that blocks unsolicited inbound |

## Scope Rules

- A VPC is regional.
- A subnet belongs to exactly one Availability Zone.
- A route table can be associated with multiple subnets.
- Every VPC has a main route table.
- A default VPC and a main route table are different concepts.

## CIDR Planning

AWS IPv4 VPC and subnet CIDRs can range from `/16` through `/28`. Subnet CIDRs
must fit inside the VPC CIDR and must not overlap.

```text
Total IPv4 addresses = 2^(32 - prefix)
AWS usable subnet addresses = total - 5
```

| CIDR | Total IPv4 | AWS usable |
|---|---:|---:|
| `/16` | 65,536 | 65,531 |
| `/20` | 4,096 | 4,091 |
| `/24` | 256 | 251 |
| `/26` | 64 | 59 |
| `/28` | 16 | 11 |

For `10.10.1.0/24`, AWS reserves:

| Address | Purpose |
|---|---|
| `10.10.1.0` | Network address |
| `10.10.1.1` | VPC router |
| `10.10.1.2` | Amazon-provided DNS |
| `10.10.1.3` | Future use |
| `10.10.1.255` | Network broadcast address; broadcast is unsupported |

Avoid overlapping CIDRs. Overlap blocks or complicates later VPC, Transit
Gateway, VPN, and on-premises connectivity.

## AWS Subnet Calculator

Use the [AWS Subnet Calculator](https://www.awssubnetcalculator.com/) as an
optional visual planning and verification tool.

For this lab:

1. Enter the VPC CIDR `10.10.0.0/16`.
2. Plan four `/24` subnets.
3. Compare the generated ranges with the Week 3 IP plan below.
4. Confirm that every subnet is inside the VPC CIDR.
5. Confirm that no subnet ranges overlap.

The calculator supports planning, but it does not replace understanding the
formula, AWS's five reserved IPv4 addresses, or the architecture decision behind
each subnet size.

## Week 3 IP Plan

| Resource | CIDR | Scope | Purpose |
|---|---|---|---|
| VPC | `10.10.0.0/16` | Region | Overall network boundary |
| Public-A | `10.10.1.0/24` | AZ A | Public tier |
| Public-B | `10.10.2.0/24` | AZ B | Public tier |
| Private-A | `10.10.11.0/24` | AZ A | Private tier |
| Private-B | `10.10.12.0/24` | AZ B | Private tier |

Each `/24` subnet has 256 total and 251 usable IPv4 addresses.

## Public and Private Subnets

A subnet name does not make it public or private.

| Route table | Routes | Associated subnets |
|---|---|---|
| Public | local + `0.0.0.0/0 -> IGW` | Public-A, Public-B |
| Private | local only in Part 1 | Private-A, Private-B |
| Main | local only | No intended lab subnet |

A subnet is public when its route table has a route to an Internet Gateway. For
IPv4 internet communication, an instance also needs a public IPv4 or Elastic
IP and applicable security rules.

## Route Selection

When multiple routes match, AWS uses longest-prefix match: the most specific
destination wins. IPv4 and IPv6 routes are evaluated separately.

Examples:

- `10.10.0.0/16 -> local` is more specific than `0.0.0.0/0 -> IGW` for VPC
  addresses.
- `0.0.0.0/0` means all IPv4 destinations.
- `::/0` means all IPv6 destinations.

## IPv4 and IPv6 Decisions

| Address/path | Important behavior |
|---|---|
| Private IPv4 | Used inside the VPC and stays with the ENI through stop/start |
| EC2 public IPv4 | Can change after stop/start and returns to the Amazon pool |
| Elastic IP | Persistent public IPv4 that can be reassociated |
| IPv6 | Globally unique; use security controls and deliberate routing |
| Egress-only IGW | Outbound-initiated IPv6 plus return traffic only |

Public IPv4 and Elastic IP addresses can create charges. Assign them only when
the workload requires them.

## Important Distinction

Route tables provide reachability. Security groups and NACLs filter traffic. A
valid route does not automatically mean traffic is allowed.

## Check Your Understanding

1. What makes a subnet public?
2. How many usable IPv4 addresses does an AWS `/24` subnet provide?
3. Why must application VPC ranges not overlap with on-premises ranges?
4. Does enabling auto-assign public IPv4 add an IGW route?
5. Which route wins: `/16` or `/0` for an address matching both?
