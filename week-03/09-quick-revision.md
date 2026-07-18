# Week 3 Quick Revision

The source classes do not include a formal quiz. Use this page for fast
self-check and interview-style revision.

## One-Line Answers

| Question | Answer |
|---|---|
| VPC scope? | One Region |
| Subnet scope? | One Availability Zone |
| AWS usable IPv4 in `/24`? | 251 |
| Public subnet rule? | Associated route table has a route to an IGW |
| IPv4 default destination? | `0.0.0.0/0` |
| IPv6 default destination? | `::/0` |
| Persistent public IPv4? | Elastic IP |
| Private IPv4 internet egress? | Private RT -> public NAT Gateway -> IGW |
| Stateful workload firewall? | Security Group |
| Stateless subnet control with deny? | Network ACL |
| Private S3/DynamoDB path? | Gateway Endpoint |
| Private AWS API ENI? | Interface Endpoint / PrivateLink |
| Direct two-VPC link? | VPC Peering |
| Transitive network hub? | Transit Gateway |
| Network metadata evidence? | VPC Flow Logs |

## Scenario Review

### Scenario 1

An EC2 instance is in a subnet named `public`, but it cannot reach the internet.
What should you check?

Check the actual route-table association, `0.0.0.0/0 -> IGW`, IGW attachment,
public IPv4 or EIP, Security Group, NACL, and application behavior.

### Scenario 2

A private EC2 instance has no public IPv4. It needs operating-system updates
from public repositories with minimal administration.

Use a public NAT Gateway and route the private subnet's IPv4 default traffic to
it. For resilient production design, use same-AZ NAT routing in each AZ.

### Scenario 3

A custom NACL allows inbound TCP 80, but the page still fails.

Because the NACL is stateless, verify outbound ephemeral return ports, rule
order, and the correct subnet association.

### Scenario 4

Private instances access S3 through NAT and NAT processing cost is high.

Use an S3 Gateway Endpoint and associate it with the correct private route
tables. Keep IAM, endpoint, bucket, KMS, and organization policies aligned.

### Scenario 5

VPC A peers with B and C. B must reach C through A.

That does not work because VPC Peering is non-transitive. Add direct B-C
peering or use Transit Gateway for hub-based transitive routing.

### Scenario 6

A Flow Log says `ACCEPT`, but the application request fails.

Check the listener, process, host firewall, DNS, TLS, and application logs. Flow
Logs show network metadata and control decisions, not payload or application
health.

## Final Recap

> CIDR defines the address space. Subnets divide it. Route tables choose the
> path. Gateways and endpoints connect destinations. Security controls filter
> traffic. Flow Logs provide evidence.
