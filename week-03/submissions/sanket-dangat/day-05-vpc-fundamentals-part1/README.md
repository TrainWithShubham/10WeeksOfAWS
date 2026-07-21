# Week 3 - Day 5: Amazon VPC Part 1

## Name
Sanket Dangat

## Tasks Completed
- [x] Watched/read the weekly content
- [x] Completed hands-on labs
- [x] Added screenshots or proof
- [x] Posted on LinkedIn
- [x] Cleaned up AWS resources


## Architecture

![VPC Architecture](diagrams/week-03-aws-two-tier-vpc-architecture.png)

---

## Architecture Decisions

### Why separate Public and Private Subnets?

Public subnets are designed for internet-facing resources, such as web servers or load balancers, while private subnets are intended for internal resources like application servers and databases. Separating them improves security by restricting direct internet access to only the resources that require it.

### Why use separate Route Tables?

Using separate route tables allows different routing policies for public and private subnets:

- **Public Route Table** → Local route (`10.10.0.0/16`) + Default route (`0.0.0.0/0`) to the Internet Gateway (IGW)
- **Private Route Table** → Local route (`10.10.0.0/16`) only

This ensures that only the public subnets have direct internet connectivity, while private subnets remain isolated from inbound internet traffic.

### Why deploy resources across two Availability Zones?

Distributing subnets across two Availability Zones improves availability and fault tolerance. If one Availability Zone becomes unavailable, resources in the other Availability Zone can continue to operate.

### Why use a /16 VPC CIDR with /24 subnets?

A `/16` VPC provides a large address space for future growth, while `/24` subnets offer a manageable number of IP addresses and allow additional subnets to be created later without overlapping existing networks.

### Why keep the Main Route Table local-only?

The Main Route Table retains only the default local route. Public and private subnets are explicitly associated with dedicated route tables, making routing behavior clear, predictable, and easier to manage.

---

## CIDR Plan

| Resource | CIDR Block | Total Addresses | Usable Addresses |
|---|---|---:|---:|
| VPC | `10.10.0.0/16` | 65,536 | 65,531 |
| Public Subnet A | `10.10.1.0/24` | 256 | 251 |
| Public Subnet B | `10.10.2.0/24` | 256 | 251 |
| Private Subnet A | `10.10.11.0/24` | 256 | 251 |
| Private Subnet B | `10.10.12.0/24` | 256 | 251 |

All subnet CIDR blocks are contained within the VPC CIDR (`10.10.0.0/16`) and do not overlap.


---

## Public vs Private

A subnet is **public** when it:

- Has a default route (`0.0.0.0/0`) pointing to an Internet Gateway (IGW).
- Can automatically assign public IPv4 addresses to instances.
- Provides internet connectivity through the Internet Gateway.

A subnet is **private** when it:

- Does not have a default route to an Internet Gateway.
- Contains only the local route.
- Does not automatically assign public IPv4 addresses.

> A subnet name alone does not make it public or private — the route table decides.

---

## Result

Built a two-AZ VPC with public and private subnets, an Internet Gateway, and dedicated route tables.

**Resources created:**

- Custom VPC **`cloudadhar-day5-vpc`** with CIDR block **`10.10.0.0/16`**
- Four subnets across two Availability Zones:
  - `cloudadhar-public-a` (`10.10.1.0/24`) — AZ A
  - `cloudadhar-private-a` (`10.10.11.0/24`) — AZ A
  - `cloudadhar-public-b` (`10.10.2.0/24`) — AZ B
  - `cloudadhar-private-b` (`10.10.12.0/24`) — AZ B
- Internet Gateway **`cloudadhar-day5-igw`** — created and attached to the VPC
- Main route table renamed to **`cloudadhar-main-rt-local-only`** — local route only, no lab subnet associated
- Public route table **`cloudadhar-public-rt`** — `0.0.0.0/0 → IGW`, associated to both public subnets
- Private route table **`cloudadhar-private-rt`** — local route only, associated to both private subnets

**Validation:** Public subnets have internet connectivity through the IGW. Private subnets are isolated from direct internet access.

### 1. VPC Created

![01_VPC_Created](screenshots/01_VPC_Created.png)

---

### 2. Subnets Created

![02_Subnets_Created](screenshots/02_Subnets_Created.png)

---

### 3. Internet Gateway Attached

![03_Internet_Gateway_Attached](screenshots/03_Internet_Gateway_Attached.png)

---

### 4. Main Route Table

![04_Main_Route_Table](screenshots/04_Main_Route_Table.png)

---

### 5. Public Route Table

![05_Public_Route_Table](screenshots/05_Public_Route_Table.png)

---

### 6. Private Route Table

![06_Private_Route_Table](screenshots/06_Private_Route_Table.png)

---

### 7. AWS VPC Resource Map

![07_AWS_VPC_Resource_Map](screenshots/07_AWS_VPC_Resource_Map.png)

---

## Where I Got Stuck

`No blocker`

---

## Cleanup

**VPC cleanup (in order):**
1. Disassociated custom route table associations
2. Deleted the four subnets
3. Deleted `cloudadhar-public-rt` and `cloudadhar-private-rt`
4. Detached `cloudadhar-day5-igw` from the VPC
5. Deleted `cloudadhar-day5-igw`
6. Deleted `cloudadhar-day5-vpc`

---

## LinkedIn Post
[LinkedIn Link](https://www.linkedin.com/posts/activity-7485174357267374080-hoc2?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEJuHJYBII9imgLntyUMaz684Imwl2w4XOM)