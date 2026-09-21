# Week 7 - Day 13: RDS, Aurora Serverless v2, Recovery, and RDS Proxy

## Name
Sanket Dangat


## Tasks Completed
- [x] Watched/read the weekly content
- [x] Completed hands-on labs
- [x] Added screenshots or proof
- [x] Posted on LinkedIn
- [x] Cleaned up AWS resources


## Architecture

## RDS High Availability, Recovery & Read Replica

![Architecture](diagram/aws-mumbai-ha-rds-recovery-read-replica.gif)


## Architecture Description

This architecture is a **highly available, multi-AZ enterprise infrastructure** designed for security, strict network isolation, and database resilience.

1. **Secure Console Access** – A Cloud Engineer establishes an authenticated session over HTTPS directly to **AWS Systems Manager Session Manager**. This acts as a secure cloud-based broker, allowing direct interactive console access to private EC2 instances over the public internet without requiring inbound SSH ports, public IP addresses, a public bastion host, or private VPC interface endpoints.

2. **Tiered Network Isolation** – The VPC network architecture segregates infrastructure across two Availability Zones (`ap-south-1a` and `ap-south-1b`) into three distinct layers: Public subnets for internet ingress/egress processing, Private App subnets for compute workloads (`DB Client`), and fully isolated Private Database subnets.

3. **Asymmetric Route Tables (No VPC Endpoints)** – Network traffic is strictly controlled via distinct routing policies, explicitly bypassing the use of VPC Interface Endpoints (AWS PrivateLink). Public subnets route external traffic via an **Internet Gateway (igw)**. Private App subnets route all internet-bound egress (`0.0.0.0/0`)—including both software package installations and systems management traffic—through redundant **NAT Gateways (nat-a/nat-b)** to eliminate redundant endpoint base infrastructure costs. The Database subnets possess no internet route, restricting traffic entirely to internal `local` VPC communication.

4. **Resilient Database Tier** – The data tier isolates database roles across individual compute nodes. The **Master RDS** instance handles write traffic and executes **Synchronous Replication** to a passive **Standby (Multi-AZ)** node for disaster recovery, alongside **Asynchronous Replication** to a standalone **Read Replica** dedicated strictly to offloading read query traffic from the EC2 clients.

5. **Native Secrets Management** – An **AWS Secrets Manager** integration connects natively with the **Master RDS** instance to orchestrate automated database master password rotations. Because no VPC endpoints are configured, the Master RDS utilizes the established NAT Gateway path to communicate outbound with the public Secrets Manager API, automatically synchronizing updated credentials across the standby and read replica nodes via engine-level replication streams.

6. **Overall Flow** – **Cloud Engineer → HTTPS → AWS Systems Manager Session Manager → Internet Gateway → NAT Gateways → App Private Subnets (EC2 Clients) → DB Security Group (Port 3306) → Isolated DB Private Subnets (Master / Standby / Read Replica RDS)**.

---

## RDS: Automating Logical Table Backups via SSM & S3

![Architecture](diagram/ssm-automation-rds-backup-to-s3.gif)


## Architecture Description

This architecture automates a secure, network-isolated **database table logical backup** to Amazon S3.

1. **Automated Orchestration** – **SSM State Manager** triggers a custom **SSM Command Document** every 24 hours without requiring open inbound management ports.

2. **Private Execution** – A private EC2 **DB Client (Worker)** receives the execution command through outbound connectivity, without requiring a public IP or bastion host.

3. **Dedicated Backup Credentials** – Created a dedicated MySQL **`backup_user`** with restricted `SELECT` permission on the `cloudadhardb.orders` table. The username and password are stored securely in **AWS Secrets Manager** instead of being hardcoded in the backup script.

4. **Secrets Retrieval** – The worker retrieves the `backup_user` credentials dynamically from **AWS Secrets Manager** using the `GetSecretValue` API call.

5. **Secure Database Export** – The worker establishes a secure **TLS connection** with the **Master RDS** using the RDS CA bundle and exports the `orders` table over the encrypted connection.

6. **Compressed Backup & Secure Storage** – The client compresses the table dump into a `.sql.gz` file and uploads it through **NAT-A** to the **versioned, encrypted S3 backup bucket** with Block Public Access enabled.

7. **Overall Flow** –

   **SSM State Manager → SSM Command Document → DB Client (Worker) → Secrets Manager → `backup_user` Credentials → TLS Connection → Master RDS `orders` Table → Gzip Compression → NAT-A → Amazon S3 Backup Bucket**

---

## Aurora Serverless v2

![Architecture](diagram/aurora_serveless_v2.gif)


## Architecture Description

This architecture creates a highly available and automatically scaling database environment using **Amazon Aurora Serverless v2** across two Availability Zones.

1. **Smart Automatic Scaling** – The Aurora Serverless v2 cluster has a **Writer Instance** in one Availability Zone and a **Reader Instance** in another. The Writer handles read and write operations through the cluster endpoint, while the Reader can handle read workloads through the Reader Endpoint. Aurora Serverless v2 automatically adjusts compute capacity based on workload.

2. **Distributed Shared Storage** – Both Aurora instances use Aurora's **distributed shared storage layer**, which automatically scales as the database grows. The storage is replicated across Availability Zones to provide high availability and durability.

3. **Smart Traffic Routing** – The DB Clients connect directly to Aurora using the **Cluster Endpoint** for read/write operations and the **Reader Endpoint** for read operations. The Cluster Endpoint always points to the current Writer, while the Reader Endpoint provides access to available Aurora Replicas.

4. **Secure Password Management** – Database credentials are securely managed using **AWS Secrets Manager** through native password integration. This prevents database credentials from being hardcoded in the DB Client configuration.

5. **Private and Controlled Access** – The Aurora instances are deployed in **private DB subnets** and are not directly accessible from the internet. The **DB Security Group** allows MySQL/Aurora traffic on port **3306** only from the authorized **App Security Group**.

---

## Aurora Serverless v2 RDS Proxy

![Architecture](diagram/aurora_serveless_v2_proxy.gif)


## Architecture Description

This architecture adds **Amazon RDS Proxy** between the DB Clients and the Aurora Serverless v2 cluster to provide managed database connection handling while maintaining a secure and highly available architecture.

1. **Connection Management** – **RDS Proxy** acts as an intermediary between the DB Clients and Aurora. It manages and reuses database connections through connection pooling, helping applications handle large numbers of connections and sudden connection spikes more efficiently.

2. **Separate Proxy Endpoints** – The DB Clients connect to RDS Proxy instead of connecting directly to Aurora. The **Proxy Default Endpoint** is used for read and write operations, while the **Proxy Reader Endpoint** is used for read workloads. RDS Proxy then manages connections to the appropriate Aurora instances.

3. **Secure Password Management** – RDS Proxy uses credentials stored in **AWS Secrets Manager** through native password integration to authenticate with the Aurora database. This keeps database credentials securely managed outside the application.

4. **Multi-Layer Network Protection** – The **Proxy Security Group** allows MySQL/Aurora traffic on port **3306** only from the **App Security Group**. The **DB Security Group** allows port **3306** only from the **Proxy Security Group**, preventing DB Clients from accessing Aurora directly.

5. **Private and Highly Available Database Layer** – The RDS Proxy and Aurora instances operate within the private VPC environment across multiple Availability Zones. The DB Clients use **AWS Systems Manager Session Manager** for secure administrative access without requiring a bastion host or inbound SSH access.

---

## Result

Successfully completed the Day 13 database lab covering Amazon RDS, Aurora Serverless v2, database recovery, read scaling, RDS Proxy, and logical database backup and restore.

**Resources created:**

- VPC `cloudadhar-day-13-vpc`
- Public Subnet A `cloudadhar-day-13-public-a`
- Public Subnet B `cloudadhar-day-13-public-b`
- Private Application Subnet A `cloudadhar-day-13-app-private-a`
- Private Application Subnet B `cloudadhar-day-13-app-private-b`
- Private Database Subnet A `cloudadhar-day-13-db-private-a`
- Private Database Subnet B `cloudadhar-day-13-db-private-b`
- Internet Gateway `cloudadhar-day-13-igw`
- Public Route Table `cloudadhar-day13-public-rt`
- Private Application Route Table `cloudadhar-day13-private-app-rt`
- Private Database Route Table `cloudadhar-day13-private-db-rt`
- NAT Gateway `cloudadhar-day13-nat-a`
- Elastic IP associated with NAT Gateway
- Private Application Default Route through NAT Gateway
- EC2 Database Client `cloudadhar-rds-client-day13`
- EC2 IAM Role `cloudadhar-ec2-ssm-role-day13`
- EC2 Client Security Group `cloudadhar-ec2-rds-client-sg-day13`
- RDS MySQL Database `cloudadhar-rds-day13`
- RDS Security Group `cloudadhar-rds-sg-day13`
- RDS Manual Snapshot `cloudadhar-rds-day13-snapshot`
- RDS PITR Restored Database `cloudadhar-rds-day13-pitr`
- RDS Read Replica `cloudadhar-rds-day13-read-replica`
- Aurora Serverless v2 Cluster `cloudadhar-aurora-serverless-day13`
- Aurora Serverless v2 Reader `cloudadhar-aurora-serverless-day13-reader-1`
- Aurora Security Group `cloudadhar-aurora-sg`
- RDS Proxy `cloudadhar-aurora-proxy-day13`
- RDS Proxy Security Group `cloudadhar-aurora-proxy-sg-day13`
- S3 Table-Backup Bucket `cloudadhar-rds-table-backups-<account-id>-ap-south-1`
- S3 Backup Prefix `day13/mysql-table-backups/`
- Secrets Manager Secret `cloudadhardb-backup-secret-day13`
- SSM Command Document `CloudAdhar-RDS-MySQL-Table-Backup-To-S3`
- State Manager Association `cloudadhar-rds-orders-backup-daily`
- SSM Association Dispatch Role `cloudadhar-ssm-association-dispatch-day13`

**Validation:** Successfully verified private RDS connectivity, manual snapshot and Point-in-Time Recovery, Read Replica replication, Aurora Serverless v2 reader and failover behavior, RDS Proxy connectivity, and the logical database backup and restore workflow.

---

## Network Architecture

**Network Design Note:** For this implementation, a dedicated custom VPC was used to provide explicit separation between public, private application, and private database tiers across two Availability Zones.

The custom VPC uses three logical subnet tiers across two Availability Zones:

| Tier | AZ A | AZ B |
|---|---|---|
| Public | `10.0.0.0/20` | `10.0.16.0/20` |
| Private Application | `10.0.32.0/20` | `10.0.48.0/20` |
| Private Database | `10.0.64.0/20` | `10.0.80.0/20` |

### Route Table Design

**Public Route Table**

`cloudadhar-day13-public-rt`

- Public Subnet A
- Public Subnet B
- Local VPC route
- `0.0.0.0/0` → Internet Gateway

**Private Application Route Table**

`cloudadhar-day13-private-app-rt`

- Private Application Subnet A
- Private Application Subnet B
- Local VPC route
- `0.0.0.0/0` → NAT Gateway

**Private Database Route Table**

`cloudadhar-day13-private-db-rt`

- Private Database Subnet A
- Private Database Subnet B
- Local VPC route
- No default internet route

![Vpc](screenshots/vpc.png)

---

## Screenshots

### 1. EC2 Database Client

Created the private EC2 database client in Private Application Subnet A. The instance uses the private application route table and NAT Gateway for required outbound connectivity, while database traffic to RDS/Aurora is permitted through Security Group rules.

![01_EC2_Database_Client](screenshots/01_EC2_Database_Client.png)

---

### 2. RDS MySQL Database

Created the private RDS MySQL source database with encryption enabled, automated backups with 1-day retention, and public access disabled.

![02_RDS_MySQL_Database](screenshots/02_RDS_MySQL_Database.png)

---

### 3. RDS Security Group

Configured the RDS Security Group to allow MySQL TCP `3306` only from the approved client Security Group.

![03_RDS_Security_Group](screenshots/03_RDS_Security_Group.png)

---

### 4. RDS Database Connectivity

Connected to the private RDS MySQL database through the EC2 client using AWS Systems Manager Session Manager. Verified the cloudadhardb database and successfully executed a query returning 3 rows.

![04_RDS_Database_Connectivity](screenshots/04_RDS_Database_Connectivity.png)

---

### 5. Manual RDS Snapshot

Created and verified a manual snapshot of the RDS MySQL database.

![05_RDS_Manual_Snapshot](screenshots/05_RDS_Manual_Snapshot.png)

---

### 6. Restore Database from Manual Snapshot

Restored the RDS MySQL database from the manual snapshot `cloudadhar-rds-day13-snapshot` as a new DB instance named `cloudadhar-rds-day13-restored`. The original database remained unchanged.

After the restored database became **Available**, connected to it and verified that the database and `orders` table were successfully restored.

```sql
SELECT TABLE_NAME, ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'cloudadhardb';

SELECT * FROM cloudadhardb.orders;
```

![06a_RDS_Manual_Snapshot_Restore](screenshots/06a_RDS_Manual_Snapshot_Restore.png)

![06b_RDS_Manual_Snapshot_Query](screenshots/06b_RDS_Manual_Snapshot_Query.png)

---

### 7. Point-in-Time Recovery

Restored the RDS database using Point-in-Time Recovery to a time between marker creation and deletion. Verified that the restored database contained the marker record and that the original source database remained unchanged.

![07_RDS_PITR_Marker](screenshots/07a_RDS_PITR_Marker.png)

![07_RDS_PITR_Restore](screenshots/07b_RDS_PITR_Restore.png)

![07_RDS_PITR_Verification](screenshots/07c_RDS_PITR_Verification.png)

![07_RDS_PITR_Source_Verification](screenshots/07d_RDS_PITR_Source_Verification.png)

---

### 8. RDS Read Replica

Created the RDS MySQL Read Replica and verified its replication status.

> **Note:** Read Replica creation required disabling Secrets Manager-managed credentials, so master credentials were switched to Self managed.

![08_RDS_Read_Replica](screenshots/08_RDS_Read_Replica.png)

---

### 9. Read Replica Validation

Verified asynchronous replication by inserting a test row on the source database, confirming its replication to the Read Replica, validating read-only behavior, and confirming that write attempts on the replica were rejected.

![09a_Read_Replica_Source](screenshots/09a_Read_Replica_Source.png)

![09b_Read_Replica_Replication](screenshots/09b_Read_Replica_Replication.png)

![09c_Read_Replica_ReadOnly](screenshots/09c_Read_Replica_ReadOnly.png)

---

### 10. Aurora Serverless v2 Cluster

Created the Aurora MySQL-Compatible Serverless v2 cluster in the private database subnets.

![10_Aurora_Serverless_v2_Cluster](screenshots/10_Aurora_Serverless_v2_Cluster.png)

---

### 11. Aurora Writer and Reader

Verified the Aurora Serverless v2 writer and reader instances.

![11a_Aurora_Writer](screenshots/11a_Aurora_Writer.png)


![11b_Aurora_Reader](screenshots/11b_Aurora_Reader.png)

---

### 12. Aurora Writer and Reader Endpoint Validation

Connected from the private EC2 Aurora database client through the Aurora writer endpoint and verified successful write access. Reconnected from the private EC2 Aurora database client through the Aurora reader endpoint and verified read-only database access.

![12_Ec2_aurora_client](screenshots/12_ec2_aurora_client.png)

![12a_Aurora_Writer_Endpoint](screenshots/12a_Aurora_Writer_Endpoint.png)

![12b_Aurora_Reader_Endpoint](screenshots/12b_Aurora_Reader_Endpoint.png)

---

### 13. Aurora Pre-Failover Validation

Connected through the Aurora cluster/writer endpoint and recorded the current writer hostname and read-only status before failover. The writer returned `@@innodb_read_only=0`.

![13_Aurora_Pre_Failover_Validation](screenshots/13_Aurora_Pre_Failover_Validation.png)

---

### 14. Aurora Failover

Performed an Aurora failover on the cloudadhar-aurora-serverless-day13 cluster and verified that the writer role moved from the previous writer instance to the other Aurora instance.

![14_Perform_Failover](screenshots/14_Perform_Failover.png)

![14_Aurora_Failover](screenshots/14_Aurora_before_after_failover_role.png)

---

### 14. Aurora Post-Failover Validation

Reconnected through the same Aurora cluster endpoint and verified that the underlying writer instance changed from `172.30.0.108` to `172.30.2.170` `@@innodb_read_only=0`, existing data remained available, and a new write succeeded after failover.

![15_Aurora_Post_Failover_Validation](screenshots/15_Aurora_Post_Failover_Validation.png)

---

### 16. RDS Proxy

Created and configured an Amazon RDS Proxy for the Aurora database cluster to provide connection pooling and secure database connectivity. The proxy uses the Aurora master secret for password-based authentication, requires TLS, and is deployed across private subnets for high availability. The default endpoint provides read/write access, with a separate read-only endpoint configured for read-only database connections.

![16_RDS_Proxy](screenshots/16_RDS_Proxy.png)

---

### 17. RDS Proxy Target Health

Verified that the Aurora targets were successfully registered and available through RDS Proxy.

![17_RDS_Proxy_Target_Health](screenshots/17_RDS_Proxy_Target_Health.png)

---

### 18. RDS Proxy Read/Write Endpoint


> **Note:** For the RDS Proxy demonstration, a **new Aurora Serverless v2 cluster is being created**. The previously created Aurora cluster was used for the earlier lab steps. Sections 18 and 19 below use the **new Aurora cluster** for demonstrating the RDS Proxy read/write and read-only endpoints.


Connected to Aurora MySQL through the RDS Proxy read/write endpoint and verified that the connection was routed to a writable backend.

![18_RDS_Proxy_Read_Write](screenshots/18_RDS_Proxy_Read_Write.png)

#### RDS Proxy TLS Certificate Verification Issue

Root Cause
----------

The MariaDB 10.5 client failed TLS server-certificate verification when
using the AWS RDS global-bundle.pem CA bundle.

`The connection returned:`

```bash
`ERROR 2026 (HY000):
TLS/SSL error: unable to get local issuer certificate
```

`The RDS Proxy itself was healthy and TLS was functioning correctly.
Connections using TLS without certificate verification succeeded, and the
same Proxy successfully established TLS 1.3 connections.`

`Testing with /root/AmazonRootCA1.pem successfully passed certificate
verification, confirming that the issue was related to CA trust-chain
validation in the MariaDB client environment rather than RDS Proxy
connectivity`


Resolution
----------

Downloaded official Amazon Trust Services:

```bash
wget https://www.amazontrust.com/repository/AmazonRootCA1.pem \
  -O /root/AmazonRootCA1.pem
```
`Use /root/AmazonRootCA1.pem as the trusted CA for the MariaDB client:`

```bash
mysql \
  -h cloudadhar-aurora-proxy-day13.proxy-chsoog6c6918.ap-south-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p \
  --ssl \
  --ssl-ca=/root/AmazonRootCA1.pem \
  --ssl-verify-server-cert \
  cloudadhardb
```

TLS was successfully established and server certificate verification
completed successfully.

---

### 19. RDS Proxy Read-Only Endpoint

Reconnected through the RDS Proxy read-only endpoint and verified read-only behavior. Read operations succeeded, while the write operation **failed as expected** because the endpoint routes connections to a read-only Aurora backend.

![19_RDS_Proxy_Read_Only](screenshots/19_RDS_Proxy_Read_Only.png)

---

## 20. Automate a Logical Table Backup with Systems Manager

### 20.1 Create the Private Backup Bucket

Created a private S3 bucket to store logical backups of the `orders` table, with Block Public Access, versioning, and SSE-S3 encryption enabled.

![20_1_RDS_Table_Backup_S3_Bucket](screenshots/20_1_RDS_Table_Backup_S3_Bucket.png)

---

### 20.2 Create a Dedicated Backup User and Secret

Created a dedicated MySQL backup user with `SELECT` permission on the `orders` table and stored its credentials securely in AWS Secrets Manager.

![20_2_RDS_Backup_User_Secret](screenshots/20_2_RDS_Backup_User_Secret.png)

---

### 20.3 Add Least-Privilege Permissions to the EC2 Role

Added least-privilege permissions to the EC2 instance role to retrieve the backup secret and upload backup objects to the designated S3 prefix.

![20_3_EC2_Backup_IAM_Permissions](screenshots/20_3_EC2_Backup_IAM_Permissions.png)

---

### 20.4 Verify the Managed-Node Prerequisites

Verified the SSM-managed EC2 database client and required backup utilities, including the MariaDB client, `jq`, `gzip`, `AWS CLI`, and `RDS CA bundle`.

![20_4_SSM_Managed_Node_Prerequisites](screenshots/20_4_SSM_Managed_Node_Prerequisites.png)

---

### 20.5 Create the SSM Command Document

Created the SSM Command document to securely export the `orders` table over TLS, compress the dump, and upload it to S3.

![20_5_SSM_Table_Backup_Document](screenshots/20_5_SSM_Table_Backup_Document.png)

---

### 20.6 Test the Document Once with Run Command

Tested the SSM Command document manually and verified successful creation of a timestamped `.sql.gz` backup in S3.

![20_6_SSM_Run_Command_Test](screenshots/20_6_SSM_Run_Command_Test.png)

---

### 20.7 Create the State Manager Association Dispatch Role

Created a dedicated IAM dispatch role for State Manager to send the approved backup command to the EC2 database client.

![20_7_SSM_Association_Dispatch_Role](screenshots/20_7_SSM_Association_Dispatch_Role.png)

---

### 20.8 Create the Scheduled State Manager Association

Created a State Manager association to automatically back up the logical `orders` table `every 24 hours`. The association executed successfully, and the resulting encrypted, `non-empty .sql.gz` backup file was verified in the `S3 bucket.`

![20_8_State_Manager_Scheduled_Association](screenshots/20_8_State_Manager_Scheduled_Orders_Table_Backup_Validation.png)

---

### 20.9 Validate the Scheduled Backup

Validated the `orders` table backup by downloading the `timestamped` `.sql.gz object` from `S3` to `EC2`, confirming successful transfer, and verifying the backup with `gzip -t` and SQL output inspection.

![20_9_Orders_Table_Backup_Gzip_Validation](screenshots/20_9_Orders_Table_Backup_Gzip_Validation.png)

---

# 22.10 Restore and Validate a Backup from S3

Downloaded a selected timestamped `.sql.gz` backup from S3 to the existing EC2 client, validated its gzip integrity, decompressed it locally, restored it into an isolated temporary MySQL database on the existing private RDS primary, verified the restored `orders` table and row counts, and removed the temporary test database and restore files.

---

## 1. Download the Backup from S3 to EC2, Validate and Decompress

Downloaded the selected backup from S3 to the EC2 client, validated its gzip integrity, and decompressed it locally

![22_10_Gzip_Validation_Decompression](screenshots/22_10_Gzip_Validation_Decompression.png)

---

## 2. Connect, Restore and Validate the Backup

Restored the S3 backup into a RDS database, verified the `orders table` and `row count`, and compared the restored data with the source database.

![22_10_Restore_And_Validate](screenshots/22_10_Restore_And_Validate.png)

---

## 3. Cleanup Temporary Database and Restore Files

After validation, remove the temporary RDS database and confirm it no longer exists.

![22_10_Cleanup_Complete](screenshots/22_10_Cleanup_Complete.png)

---

## Where I Got Stuck

I initially faced a TLS certificate verification error while connecting to the RDS Proxy using the MariaDB client and `global-bundle.pem`.

The Proxy was healthy and TLS connectivity was working, but certificate verification failed with:

```bash
ERROR 2026 (HY000): TLS/SSL error: unable to get local issuer certificate
```

After testing with the official `AmazonRootCA1.pem` certificate, the connection succeeded and the RDS Proxy certificate was verified successfully.

---

## Additional Documentation

- [Week 7 Design Decisions](../design-decisions.md)

---

## Cleanup

**Day 13 cleanup should be performed only after all required evidence has been captured.**

1. Remove the State Manager association
2. Remove the SSM association dispatch role
3. Delete the SSM Command document
4. Delete all SSM-related resources and associations
5. Delete all objects from the logical backup S3 bucket
6. Delete the Day 13 backup S3 bucket
7. Delete the Day 13 backup Secrets Manager secret
8. Delete the RDS Proxy
9. Delete the new Aurora Serverless v2 cluster created for the RDS Proxy demonstration
10. Delete the Aurora reader/instances associated with the new Proxy demonstration cluster
11. Delete the original Aurora reader
12. Delete the original Aurora Serverless v2 cluster
13. Delete the RDS Read Replica
14. Delete the PITR restored database
15. Delete the manually restored database `cloudadhar-rds-day13-restored`
16. Delete the manual RDS snapshot
17. Delete the source RDS database
18. Terminate the EC2 database client
19. Delete Day 13 Security Groups
20. Delete the NAT Gateway
21. Release the NAT Gateway Elastic IP
22. Delete custom route tables
23. Delete all six subnets
24. Detach and delete the Internet Gateway
25. Delete the VPC `cloudadhar-day-13-vpc`

---

## LinkedIn Posts

[LinkedIn Link](https://lnkd.in/p/dPk9np5D)


[LinkedIn Link](https://lnkd.in/p/dZqKbwmJ)


[LinkedIn Link](https://lnkd.in/p/dXapmmrp)
