# CIDR Plan

## VPC CIDR

| Resource | CIDR | Total IPv4 Addresses | Usable IPv4 Addresses |
|----------|------|---------------------:|----------------------:|
| cloudadhar-day5-vpc | 10.10.0.0/16 | 65,536 | 65,531 |

---

## Subnet CIDRs

| Subnet | Availability Zone | CIDR | Total IPv4 | Usable IPv4 |
|---------|-------------------|------|-----------:|------------:|
| cloudadhar-public-a | ap-south-1a | 10.10.1.0/24 | 256 | 251 |
| cloudadhar-private-a | ap-south-1a | 10.10.11.0/24 | 256 | 251 |
| cloudadhar-public-b | ap-south-1b | 10.10.2.0/24 | 256 | 251 |
| cloudadhar-private-b | ap-south-1b | 10.10.12.0/24 | 256 | 251 |

---

## AWS Reserved IPv4 Addresses

AWS reserves five IPv4 addresses in every subnet.

| Address | Purpose |
|----------|---------|
| x.x.x.0 | Network address |
| x.x.x.1 | VPC Router |
| x.x.x.2 | Amazon DNS |
| x.x.x.3 | Reserved for future use |
| x.x.x.255 | Broadcast address (broadcast is not supported) |

Example for subnet `10.10.1.0/24`:

| Address | Purpose |
|----------|---------|
| 10.10.1.0 | Network |
| 10.10.1.1 | Router |
| 10.10.1.2 | DNS |
| 10.10.1.3 | Reserved |
| 10.10.1.255 | Broadcast |

---

## Validation

- All subnet CIDRs are within the VPC CIDR (`10.10.0.0/16`).
- No subnet CIDRs overlap.
- Each subnet uses a `/24` network.
- Each subnet provides **251 usable IPv4 addresses**.
- The VPC provides **65,531 usable IPv4 addresses**.

---

## Formula

```
Total Addresses = 2^(32 − Prefix)

Usable Addresses = Total − 5
```