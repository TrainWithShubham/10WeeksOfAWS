# Week 5 Design Decisions

---

# Week 5 - Day 9: ALB-Backed Auto Scaling

## Decision Table

| Decision | Classroom Choice | Production Choice | Reason |
|----------|------------------|-------------------|--------|
| **Instance subnets** | Public | Private | Production EC2 instances should run in private subnets for improved security, while the ALB remains internet-facing. |
| **ASG capacity** | `1 / 1 / 2` | `2 / 2 / 6` (example) | Maintaining at least two instances across multiple Availability Zones improves availability and fault tolerance. |
| **Launch Template reference** | Tested version | Default (Latest Stable) version | Using a validated Launch Template version ensures predictable deployments and simplifies rollback. |
| **Scaling metric** | Average CPU 50% | CPU, Request Count per Target, or custom CloudWatch metrics | Production workloads often combine multiple metrics for more accurate scaling decisions. |
| **Health sources** | EC2 and ELB | EC2 and ELB | Combining EC2 and ALB health checks enables automatic replacement of unhealthy instances while ensuring application-level availability. |
| **Listener** | HTTP `80` | HTTPS `443` | Production applications should encrypt client traffic using TLS certificates from AWS Certificate Manager (ACM). |
| **Release method** | Rolling updates | Blue/Green or Canary deployment | Progressive deployment strategies reduce deployment risk and simplify rollback. |
| **Session state** | In-memory | External session store (Amazon ElastiCache or DynamoDB) | External session storage prevents session loss during scaling and instance replacement. |
| **Load balancer type** | Application Load Balancer (ALB) | Application Load Balancer (ALB) | ALB provides Layer 7 routing, health checks, sticky sessions, and seamless Auto Scaling integration. |

## Failure Review

### 1. One application process failing while EC2 remains running

The ALB health check detects the failed application and marks the target as **Unhealthy**. Traffic is routed only to healthy instances. If Auto Scaling uses ELB health checks, the unhealthy instance is automatically replaced.

### 2. One Availability Zone becoming unavailable

The ALB automatically routes requests to healthy instances in the remaining Availability Zone. Auto Scaling launches replacement instances when capacity becomes available.

### 3. A bad Launch Template version

New instances may fail to launch or fail health checks. Revert the Auto Scaling Group to the last known stable Launch Template version and replace affected instances.

### 4. Scale-out event during high traffic

Auto Scaling launches additional EC2 instances. After passing ALB health checks, the new instances begin serving traffic automatically.

### 5. A scale-in event while requests are still active

The ALB performs **connection draining (deregistration delay)** so existing requests complete before the instance is terminated.

### 6. A Spot interruption in a Mixed Instances group

The Auto Scaling Group launches replacement instances to maintain desired capacity. On-Demand instances continue serving traffic if Spot capacity becomes unavailable.

---

# Week 5 - Day 10: ALB Blue/Green Routing and NLB

## Decision Table

| Decision | Classroom Choice | Production Choice | Reason |
|----------|------------------|-------------------|--------|
| **Deployment strategy** | Manual Blue/Green | AWS CodeDeploy Blue/Green | Automated deployments reduce downtime and simplify rollback. |
| **Traffic shifting** | Manual 80/20 weighted routing | Gradual automated traffic shifting | Progressive traffic shifting minimizes deployment risk. |
| **Routing rules** | Host-based, Path-based, Weighted | Same | Advanced Layer 7 routing enables flexible application delivery. |
| **Target group stickiness** | Enabled | Enabled when session affinity is required | Maintains user sessions on the same backend target. |
| **Load balancer type** | ALB + NLB | ALB + NLB | ALB handles Layer 7 routing, while NLB provides high-performance Layer 4 TCP/TLS load balancing. |
| **TLS termination** | ACM Wildcard Certificate | ACM with automatic certificate renewal | ACM simplifies certificate management and renewal. |
| **Backend instances** | Blue and Green EC2 | Multiple EC2 instances across multiple AZs | Improves availability and fault tolerance. |
| **Health checks** | `/health.html` | Application-specific health endpoints | Health checks ensure traffic is sent only to healthy targets. |
| **DNS** | Amazon Route 53 Alias Records | Amazon Route 53 Alias Records | Alias records integrate directly with AWS load balancers without requiring IP addresses. |

## Failure Review

### 1. Blue targets becoming unhealthy

The ALB marks Blue targets as unhealthy and routes traffic only to healthy targets based on listener rules and health checks.

### 2. Green targets becoming unhealthy during a weighted release

Health checks automatically remove unhealthy Green targets from service, causing traffic to shift to healthy Blue targets until the issue is resolved.

### 3. One Availability Zone becoming unavailable

Both the ALB and NLB continue serving requests using healthy targets in the remaining Availability Zone.

### 4. TLS certificate expiration

Using AWS Certificate Manager enables automatic certificate renewal, preventing service interruptions caused by expired certificates.

### 5. Connection draining during deployment

The ALB waits for active client requests to complete before deregistering targets, ensuring graceful deployments with minimal user impact.

### 6. Route 53 DNS resolution

Amazon Route 53 Alias records automatically resolve to the active ALB and NLB endpoints without requiring manual IP address management.