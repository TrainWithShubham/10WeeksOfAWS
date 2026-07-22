# Comparisons – Week 03 Day 5

## 1. Default VPC vs Custom VPC

| Default VPC | Custom VPC |
|-------------|------------|
| Created automatically by AWS | Created manually by the user |
| Default subnets in each Availability Zone | No subnets by default |
| Internet Gateway already attached | Internet Gateway must be created and attached |
| Ready to launch EC2 instances | Requires manual network configuration |
| Suitable for testing | Preferred for production environments |

---

## 2. Public Subnet vs Private Subnet

| Public Subnet | Private Subnet |
|---------------|----------------|
| Can communicate with the internet through an Internet Gateway | No direct internet access |
| Auto-assign Public IPv4 enabled | Auto-assign Public IPv4 disabled |
| Used for web servers, bastion hosts | Used for databases and internal services |
| Associated with Public Route Table | Associated with Private Route Table |

---

## 3. Internet Gateway vs Route Table

| Internet Gateway | Route Table |
|------------------|-------------|
| Connects a VPC to the internet | Decides where network traffic should go |
| Attached to the VPC | Associated with subnets |
| Provides internet connectivity | Defines routing rules such as Local or IGW |

---

## 4. CIDR /16 vs CIDR /24

| /16 | /24 |
|------|------|
| Used for the VPC | Used for individual subnets |
| 65,536 total IP addresses | 256 total IP addresses |
| Larger address space | Smaller address space |

---

## 5. Overlapping CIDR vs Non-Overlapping CIDR

| Overlapping CIDR | Non-Overlapping CIDR |
|------------------|----------------------|
| Two or more subnets share the same IP address range | Each subnet has a unique IP address range |
| AWS does not allow overlapping subnets within the same VPC | AWS allows the subnet to be created |
| Causes IP address conflicts | Traffic can be routed correctly |
| Example: Two subnets using `10.10.1.0/24` | Example: `10.10.1.0/24` and `10.10.11.0/24` |

### Why should CIDR blocks not overlap?

Each subnet in a VPC must have a unique CIDR block. If two subnets use the same IP range, AWS cannot determine which subnet owns an IP address.

For example:

- Public-A → `10.10.1.0/24`
- Private-A → `10.10.1.0/24` ❌

Both subnets contain the same IP addresses, so an address like `10.10.1.20` could belong to either subnet. This creates an IP conflict, and AWS prevents the subnet from being created by displaying a **CIDR overlap** error.

Correct configuration:

- Public-A → `10.10.1.0/24`
- Private-A → `10.10.11.0/24` ✅

Since the CIDR blocks are different, AWS can correctly identify which subnet owns each IP address.
