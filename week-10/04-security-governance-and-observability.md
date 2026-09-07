# Day 19 - Security, Governance and Observability

AWS Zero To Hero - CloudAdhar x TrainWithShubham  
Live class: Sunday, 6 September 2026  
Exam focus: SAA-C03 Domains 1-4

## Learning outcomes

By the end of this lesson, you should be able to:

- protect identities, keys, secrets, certificates, and data;
- distinguish prevention, detection, investigation, and remediation;
- choose the correct AWS service from a security or observability requirement;
- explain Cognito User Pools, Google federation, and Identity Pools;
- compare CloudWatch, CloudTrail, AWS Config, and X-Ray;
- use Systems Manager for controlled operations without opening SSH;
- connect Day 19 decisions to the Well-Architected pillars.

## Protect: identity, keys, secrets, and certificates

| Requirement | Best starting service | Exam cue |
|---|---|---|
| Customer-managed encryption policy and key administration | AWS KMS customer managed key | Separate key administrators from key users; protect key policies and deletion |
| Database password or API token with rotation | Secrets Manager | Purpose-built secret lifecycle and rotation |
| Hierarchical configuration or encrypted parameter | Systems Manager Parameter Store | `SecureString` uses KMS; use least-privilege reads |
| Public TLS certificate | AWS Certificate Manager | CloudFront certificates are requested in `us-east-1`; Regional services use their supported Region |
| Application sign-up, sign-in, MFA, and JWTs | Cognito User Pool | Authentication and federation |
| Temporary AWS credentials for an application identity | Cognito Identity Pool | Authorization through mapped least-privilege IAM roles |

KMS uses envelope encryption: a data key encrypts application data, while KMS protects the encrypted data key. Key policies are central to authorization. Never put credentials or real secrets in code, logs, screenshots, or learner repositories.

## Detect and prioritize

| Service | Primary question | Do not confuse it with |
|---|---|---|
| GuardDuty | Does activity appear suspicious or malicious? | CloudTrail storage or preventive firewall controls |
| Macie | Where is sensitive data in S3? | General threat detection |
| Inspector | Which EC2, ECR, or Lambda workloads have vulnerabilities? | Runtime threat detection |
| Security Hub | Which security findings and controls need priority? | A replacement for source detectors |

A useful response pattern is: **detect -> centralize -> route -> investigate -> remediate**. A finding is evidence to investigate, not permission for an automatic destructive action.

## Observe, audit, govern, and trace

| Requirement | Service |
|---|---|
| Metrics, logs, alarms, dashboards, and application telemetry | CloudWatch |
| Who changed or deleted an AWS resource | CloudTrail |
| Whether resources meet configuration policy | AWS Config |
| Why a distributed request is slow or failing | X-Ray |

CloudWatch alarms should measure customer-impacting symptoms such as errors, latency, failed orders, queue age, or availability. Set periods, statistics, dimensions, missing-data behavior, retention, and notification actions deliberately.

CloudTrail Event history provides recent management-event visibility. A trail delivers ongoing events to protected destinations. Management events describe control-plane operations; S3 object-level operations such as `GetObject` are data events and must be explicitly enabled.

AWS Config records supported resource configuration and evaluates rules. It is different from CloudFormation drift detection: Config evaluates compliance and history, while drift compares supported deployed properties with a stack template.

X-Ray complements metrics and logs with distributed trace segments, service dependencies, latency, errors, annotations, and sampling.

## Operate with Systems Manager

- **Session Manager:** shell access or port forwarding without inbound SSH/RDP or a bastion host.
- **Run Command:** approved commands across managed nodes.
- **Patch Manager:** patch baselines and compliance reporting.
- **State Manager:** maintain recurring desired configuration.
- **Automation:** controlled, repeatable remediation runbooks.
- **Parameter Store:** hierarchical application configuration.

CloudFormation provisions infrastructure; Systems Manager operates and remediates resources after or alongside provisioning. Use tags, approvals, concurrency limits, error thresholds, logging, and idempotent runbooks.

## Cognito and Google/Gmail federation

A Cognito User Pool authenticates application users and issues tokens. Google federation lets users sign in with Google/Gmail accounts without sharing their Gmail password with the application. An Identity Pool is separate: it exchanges an authenticated identity for temporary AWS credentials through an IAM role mapping.

For a browser application, use a User Pool app client without a client secret, configure Google as an identity provider, request only `openid`, `email`, and `profile`, and use the Authorization Code flow with PKCE. A Google sign-in does not automatically grant AWS API access.

## Well-Architected and exam method

Day 19 primarily supports Security and Operational Excellence, but decisions affect all six pillars:

- Security: least privilege, encryption, identity, findings, and auditability.
- Reliability: actionable alarms, configuration history, and controlled recovery.
- Performance Efficiency: useful statistics, dashboards, and trace analysis.
- Cost Optimization: retention, metric cardinality, data-event scope, and scan scope.
- Operational Excellence: observe, learn, automate, and document runbooks.
- Sustainability: right-size capacity and remove unused resources.

For SAA-C03 questions, identify the resource and outcome first: key, secret, certificate, identity, finding, metric, API event, configuration item, trace, or managed node. Then check Region, account boundary, encryption, logging scope, data-event settings, retention, and least privilege.

## Quick knowledge check

1. Automatic database password rotation: **Secrets Manager**.
2. Sensitive personal data in S3: **Macie**.
3. Who changed an S3 policy and whether the bucket is compliant: **CloudTrail + AWS Config**.
4. Private EC2 administration without port 22: **Session Manager**.
5. Temporary AWS credentials for a mobile user: **Cognito Identity Pool with least-privilege IAM roles**.
