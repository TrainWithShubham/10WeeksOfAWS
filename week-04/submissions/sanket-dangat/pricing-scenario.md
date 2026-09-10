# Week 4 – Pricing Scenarios

## Pricing Scenarios

| Requirement | Recommended Option | Reason |
|---|---|---|
| A new API has unpredictable demand. | **On-Demand Instances** | No long-term commitment, allowing capacity to scale up or down based on demand while paying only for the resources used. |
| A checkpointed rendering fleet tolerates interruption. | **Spot Instances** | Provides the lowest compute cost for fault-tolerant workloads that can handle interruptions and resume from checkpoints. |
| A company has steady compute spend across services. | **Compute Savings Plans** | Delivers cost savings with flexibility across Amazon EC2, AWS Fargate, and AWS Lambda in exchange for a consistent usage commitment. |
| Licensed software requires physical-host visibility. | **Dedicated Hosts** | Provides dedicated physical servers to satisfy software licensing, compliance, and regulatory requirements. |
| A stable fleet uses the same EC2 family in one Region. | **EC2 Instance Savings Plans** | Offers significant savings for predictable workloads using the same EC2 instance family within a specific AWS Region. |

---

## Summary

| Pricing Option | Best For |
|---|---|
| **On-Demand Instances** | Short-term, unpredictable, or variable workloads |
| **Spot Instances** | Fault-tolerant, interruptible workloads with the lowest cost |
| **Compute Savings Plans** | Consistent compute usage across multiple AWS compute services |
| **Dedicated Hosts** | Licensing, compliance, and physical server visibility requirements |
| **EC2 Instance Savings Plans** | Predictable EC2 workloads using the same instance family in one Region |