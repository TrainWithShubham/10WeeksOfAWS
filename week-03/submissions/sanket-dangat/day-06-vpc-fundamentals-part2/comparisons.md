# Week 3 – VPC Components Comparisons


## 1. NAT Gateway vs NAT Instance

A public NAT Gateway lives in a public subnet and uses an Elastic IP. A private
subnet routes `0.0.0.0/0` to it. The NAT Gateway then follows the public
subnet's IGW route.

| NAT Gateway | NAT Instance |
|---|---|
| Managed AWS service | EC2 instance managed by you |
| Recommended for most workloads | Use for customization requirements |
| Managed capacity within service design | Instance type limits capacity |
| No Security Group attached | Security Group can be attached |
| Hourly and data-processing charges | EC2, EBS, public IPv4, and operations |
| Deploy per AZ in classic resilient design | You design scaling and failover |

Exam pointer: choose NAT Gateway for private IPv4 egress with minimal
administration. Consider a NAT Instance or appliance only when custom packet
handling justifies the operational burden.

---

## 2. Security Groups vs Network ACLs

| Characteristic | Security Group | Network ACL |
|---|---|---|
| Scope | Resource or ENI | Subnet |
| Rules | Allow only | Allow and deny |
| State | Stateful | Stateless |
| Return traffic | Automatically allowed | Must be allowed explicitly |
| Evaluation | All attached rules combine | Lowest matching rule number wins |
| New/default behavior | No inbound, allow outbound | Default NACL allows; custom starts deny-all |
| Best use | Primary workload firewall | Subnet guardrail or explicit deny |

NACL return rules must allow ephemeral ports. A safe broad training range is
TCP `1024-65535`; narrow it in production only after confirming OS and client
behavior.

Example HTTP flow:

```text
Client request: 203.0.113.10:53000 -> EC2:80
Server response: EC2:80 -> 203.0.113.10:53000
```

The inbound NACL needs destination port 80. The outbound NACL needs the
client's ephemeral destination port.

---

## 3. Gateway vs Interface VPC Endpoints

| Area | Gateway Endpoint | Interface Endpoint |
|---|---|---|
| Services | S3 and DynamoDB | Many AWS and private endpoint services |
| Network object | Route-table prefix-list target | ENI with private IP |
| PrivateLink | No | Yes |
| Security Group | Not attached | Attached to endpoint ENI |
| DNS | Normal service DNS | Private DNS can map normal hostname to private IP |
| Cost | No endpoint hourly/processing charge | Endpoint-hour and processing charge |

Decision guide:

- S3 or DynamoDB from a private subnet: Gateway Endpoint first.
- Supported API needing private IP and DNS: Interface Endpoint.
- Arbitrary public internet destination: NAT, proxy, or another egress design.

An endpoint does not replace authorization. Effective access can include IAM,
endpoint policy, service resource policy, KMS key policy, SCP, and permission
boundary decisions.

## 4. VPC Peering vs Transit Gateway

| VPC Peering | Transit Gateway |
|---|---|
| Direct one-to-one VPC connection | Managed regional hub |
| Routes required on both sides | VPC and TGW route tables control paths |
| Non-overlapping CIDRs required | Non-overlapping planning still matters |
| Not transitive | Supports transitive routing through the hub |
| Best for a few direct links | Best for larger hub-and-spoke or hybrid networks |

Peering trap: A-B and A-C peering does not create B-C connectivity. Create a
direct B-C peer or use Transit Gateway.