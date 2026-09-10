# Week 7 - Design Decisions

---

# Week 7 - Day 13: RDS, Aurora Serverless v2, Recovery, and RDS Proxy

## Design Decisions

### 1. Private Database Subnets

**Decision:**

Deploy RDS and Aurora database resources in dedicated private database subnets across multiple Availability Zones.

**Why:**

Database resources should not be directly reachable from the public internet. Separating database subnets from application subnets provides a clear network boundary and supports a more secure three-tier architecture.

---

### 2. Multi-AZ Database Subnet Group

**Decision:**

Use private database subnets in multiple Availability Zones for the RDS database subnet group.

**Why:**

An RDS DB subnet group must span at least two Availability Zones. Using database subnets across multiple AZs provides the network foundation required for Multi-AZ database deployments and improves architectural resilience.

---

### 3. Security Group Based Database Access

**Decision:**

Allow database traffic only from the application-layer security group rather than allowing unrestricted access from the VPC CIDR.

**Why:**

Security groups should follow least-privilege principles. Application workloads are explicitly trusted to communicate with the database, while unrelated resources are prevented from accessing the database port.

---

### 4. Private RDS Connectivity

**Decision:**

Keep the RDS instance private and validate connectivity from an authorized private workload.

**Why:**

The database does not require public accessibility for the application architecture. Private connectivity reduces the attack surface and keeps database traffic inside the VPC.

---

### 5. Manual Snapshot and Point-in-Time Recovery

**Decision:**

Validate both manual database snapshots and Point-in-Time Recovery (PITR).

**Why:**

A manual snapshot provides a user-controlled recovery point that can be retained for longer-term recovery requirements. PITR provides more granular recovery capability by restoring the database to a specific point within the available backup window.

---

### 6. Read Replica

**Decision:**

Use an RDS Read Replica to validate asynchronous replication and read-scaling behavior.

**Why:**

Read Replicas can reduce read pressure on the primary database and provide a separate database endpoint for read-heavy workloads. They also demonstrate how asynchronous replication can be used independently from Multi-AZ high availability.

---

### 7. Aurora Serverless v2

**Decision:**

Evaluate Aurora Serverless v2 with a reader instance and validate failover behavior.

**Why:**

Aurora Serverless v2 provides dynamically scalable compute capacity while retaining Aurora's managed database architecture. Testing a reader and performing a failover demonstrates how Aurora can support workload scaling and database availability.

---

### 8. RDS Proxy

**Decision:**

Place RDS Proxy between the application workload and the Aurora database cluster.

**Why:**

RDS Proxy provides a managed connection layer between applications and the database. Connection pooling can reduce the overhead of repeatedly establishing database connections and can improve application resilience during database failover events.

---

### 9. Logical Database Backup and Restore

**Decision:**

Validate a logical database backup and restore workflow in addition to native RDS backup mechanisms.

**Why:**

Native RDS snapshots and PITR provide infrastructure-level recovery, while logical backups provide a database-level recovery mechanism. Validating both approaches demonstrates multiple recovery strategies rather than relying on a single backup mechanism.

---

### 10. Resilience and Recovery Validation

**Decision:**

Treat backup, recovery, replication, and failover mechanisms as testable workflows rather than assuming that configured services are sufficient.

**Why:**

A backup or resilience strategy is only useful when the recovery and failover processes are understood and validated. Testing snapshots, PITR, Read Replica behavior, Aurora failover, RDS Proxy connectivity, and logical restore provides practical evidence that the implemented mechanisms work as expected.

---

# Week 7 - Day 14: DynamoDB, Streams, TTL, and Architecture Decisions

## Design Decisions

### 1. DynamoDB Access-Pattern-First Design

**Decision:**

Design the DynamoDB table around known application access patterns and use the base table, GSI1, and LSI1 for targeted queries.

**Why:**

DynamoDB is designed around predictable access patterns. Using Query operations through appropriate keys and indexes avoids unnecessary full-table scans and provides more efficient data access.

---

### 2. Global Tables

**Decision:**

Evaluate DynamoDB Global Tables conceptually without creating a replica for this lab.

**Why:**

Global Tables are appropriate when an application requires multi-Region availability, local access for global users, and multi-Region writes.

No Global Table replica was created as part of the Day 14 practical.

---

### 3. DAX

**Decision:**

Evaluate DynamoDB Accelerator (DAX) conceptually without creating a DAX cluster.

**Why:**

DAX is appropriate for DynamoDB workloads with frequent repeated reads where very low-latency cached access is required and eventual consistency is acceptable.

DAX is not intended to solve poor access-pattern design, hot partitions, unnecessary table scans, or write-heavy workloads.

---

### 4. ElastiCache

**Decision:**

Evaluate ElastiCache engine choices conceptually without creating an ElastiCache cache.

**Why:**

Redis OSS/Valkey is suitable for richer data structures, sessions, counters, rate limiting, leaderboards, and Pub/Sub.

Memcached is suitable for simpler disposable object caching.

DAX is preferred when the requirement is specifically DynamoDB-native read acceleration.

---

### 5. DynamoDB Streams and Lambda

**Decision:**

Use DynamoDB Streams with Lambda to process database changes asynchronously.

**Why:**

DynamoDB Streams capture item-level changes such as INSERT, MODIFY, and REMOVE events. Lambda can consume these events without requiring the application to synchronously perform additional processing.

The Day 14 practical validated the UI → DynamoDB → Stream → Lambda flow.

---

### 6. DynamoDB TTL

**Decision:**

Use DynamoDB TTL for automatically expiring temporary session data.

**Why:**

TTL allows expired items to be removed automatically without requiring the application to continuously perform cleanup operations.

The `ExpiresAt` attribute was used for the Day 14 TTL demonstration.

---

### 7. DynamoDB Query over Scan

**Decision:**

Prefer targeted Query operations when the required partition key and access pattern are known.

**Why:**

Query operations retrieve items from a specific partition and are generally more efficient than scanning the entire table. The Day 14 practical demonstrated the difference between Query and Scan read consumption.

---

### 8. GSI for Order-ID Lookup

**Decision:**

Use GSI1 to support direct order-ID lookups without requiring the customer partition key.

**Why:**

The base table is organized around the customer access pattern. GSI1 provides an additional access path for searching an order directly by its order ID.

---

### 9. LSI for Status-Based Customer Order Queries

**Decision:**

Use LSI1 to support status-based queries within a customer's partition.

**Why:**

The LSI provides an alternate sort-key access pattern while retaining the same base partition key. A status-prefix query can therefore retrieve orders for a customer based on status without scanning unrelated items.

---

## Resource Creation Scope

Global Tables, DAX, and ElastiCache were evaluated as technology and architecture decisions only.

No Global Table replica, DAX cluster, or ElastiCache cache was created as part of the Day 14 practical.

The Day 14 resources documented in the main README are limited to the DynamoDB tables, indexes, TTL configuration, DynamoDB Stream, Lambda functions, IAM resources, temporary Function URL, and test data actually created during the lab.