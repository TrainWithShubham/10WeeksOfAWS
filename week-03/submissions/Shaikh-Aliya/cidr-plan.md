
# CIDR Plan – Week 03 Day 5

## Objective

The objective of this CIDR plan is to divide the VPC network into multiple non-overlapping subnets distributed across two Availability Zones. This allows public-facing resources and private resources to be isolated while maintaining high availability.

---

## VPC CIDR

| Resource | CIDR Block | Description |
|----------|------------|-------------|
| VPC | 10.10.0.0/16 | Main network for the entire VPC |

- CIDR Block: `10.10.0.0/16`
- Total IP Addresses: **65,536**
- This CIDR range is divided into smaller subnet CIDR blocks.

---

## Subnet Plan

| Subnet | Availability Zone | CIDR Block | Purpose |
|---------|-------------------|------------|---------|
| Public-A | ap-south-1a | 10.10.1.0/24 | Public resources |
| Private-A | ap-south-1a | 10.10.11.0/24 | Private resources / Database |
| Public-B | ap-south-1b | 10.10.2.0/24 | Public resources |
| Private-B | ap-south-1b | 10.10.12.0/24 | Private resources / Database |

---

## CIDR Explanation

### VPC CIDR (/16)

```
10.10.0.0/16
```

- Network Prefix: 16 bits
- Host Bits: 16 bits
- Total IP Addresses: **65,536**

This CIDR block represents the complete IP address space available for the VPC.

---

### Subnet CIDR (/24)

Example:

```
10.10.1.0/24
```

- Network Prefix: 24 bits
- Host Bits: 8 bits
- Total IP Addresses: **256**
- Usable IP Addresses in AWS: **251**
  (AWS reserves 5 IP addresses in every subnet.)

The same `/24` size is used for all four subnets.

---

## Why Different CIDR Blocks?

Each subnet must have a unique CIDR block.

Examples:

- Public-A → `10.10.1.0/24`
- Private-A → `10.10.11.0/24`

These ranges do not overlap, allowing AWS to route traffic correctly.

---

## High Availability Design

The subnets are distributed across two Availability Zones.

- Availability Zone A
  - Public-A
  - Private-A

- Availability Zone B
  - Public-B
  - Private-B

This architecture improves availability because if one Availability Zone becomes unavailable, resources in the other zone can continue serving traffic.

---

## Summary

- VPC CIDR: `10.10.0.0/16`
- Four `/24` subnets
- No overlapping CIDR ranges
- Two Availability Zones
- Separate Public and Private networks
