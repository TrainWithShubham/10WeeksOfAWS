# Week 3 - Day 6: Amazon VPC Part 2

## Name

Sanket Dangat

## Tasks Completed

- [x] Watched/read the weekly content
- [x] Extended the VPC
- [x] Completed hands-on labs
- [x] Added screenshots or proof
- [x] Posted on LinkedIn
- [x] Cleaned up AWS resources

---

## Architecture

![VPC Extend Architecture](diagrams/week-03-day6-extend-vpc.gif)

---

## Architecture Decisions

## Why NAT Gateway per Availability Zone (AZ)?

- Improves **high availability** by avoiding a single point of failure.
- Keeps traffic within the **same Availability Zone**, helping reduce cross-AZ data transfer costs.
- Ensures private instances in each AZ can continue accessing the internet even if another AZ becomes unavailable.
- Follows **AWS best practices** for production workloads.

---

## Why use an S3 Gateway Endpoint?

- Enables private instances to access **Amazon S3** without using the public internet.
- Reduces **NAT Gateway data processing costs** by routing S3 traffic through the Gateway Endpoint.
- Keeps S3 traffic on the **AWS network**, improving security.
- Supports **endpoint policies** to control access to specific S3 buckets.

---

## Result

Extended the Day 5 VPC by adding secure outbound internet access, private AWS service connectivity, subnet-level filtering, and network traffic monitoring.

**Resources created:**

* NAT Gateway **`cloudadhar-day6-nat-a`**
* Elastic IP
* Private Route Table **`cloudadhar-private-a-rt`**
* Amazon Linux 2023 Private EC2 instance
* Public EC2 web server
* Custom Network ACL
* Amazon S3 Gateway Endpoint
* Amazon EC2 Interface Endpoint
* VPC Flow Logs

**Validation:**

* Private EC2 has no public IPv4 address
* Session Manager access successful
* Internet connectivity verified through NAT Gateway
* AWS CLI authentication successful
* HTTP allowed by Security Group
* Temporary NACL deny blocked HTTP traffic
* Removing deny restored connectivity
* Amazon S3 traffic routed through Gateway Endpoint
* EC2 API resolved through Interface Endpoint using Private DNS
* Flow Logs recorded both ACCEPT and REJECT traffic

---

### 1. NAT Gateway Available

![01_NAT_Gateway_Available](screenshots/01_NAT_Gateway_Available.png)

---

### 2. Private-A Route Table

![02_Private_A_Route_Table](screenshots/02_Private_A_Route_Table.png)

---

### 3. Public Route Table

![03_Public_Route_Table](screenshots/03_Public_Route_Table.png)

---

### 4. Private EC2 Instance

![04_Private_EC2_Instance](screenshots/04_Private_EC2_Instance.png)

---

### 5. Session Manager Connection

![05_Session_Manager](screenshots/05_Session_Manager.png)

---

### 6. Internet Connectivity Validation

![06_Curl_Internet_Access](screenshots/06_Curl_Internet_Access.png)

---

### 7. AWS CLI Identity Validation

![07_STS_Get_Caller_Identity](screenshots/07_STS_Get_Caller_Identity.png)

---

### 8. Web Server Security Group

![08_Web_Server_Security_Group](screenshots/08_Web_Server_Security_Group.png)

---

### 9. Web Server Running

![09_Web_Server_Running](screenshots/09_Web_Server_HTTP_Access.png)

---

### 10. Custom Network ACL

![10_Custom_NACL](screenshots/10_Custom_NACL.png)

---

### 11. HTTP Blocked by Network ACL

![11_HTTP_Blocked_NACL](screenshots/11_HTTP_Blocked_NACL.png)

---

### 12. HTTP Restored

![12_HTTP_Restored](screenshots/12_HTTP_Restored.png)

---

### 13. Amazon S3 Gateway Endpoint

![13_S3_Gateway_Endpoint](screenshots/13_S3_Gateway_Endpoint.png)

---

### 14. S3 Prefix List Route

![14_S3_Prefix_List_Route](screenshots/14_S3_Prefix_List_Route.png)

---

### 15. Amazon S3 Validation

![15_S3_List_Buckets](screenshots/15_S3_List_Buckets.png)

---

### 16. EC2 Interface Endpoint

![16_Interface_Endpoint](screenshots/16_Interface_Endpoint.png)

---

### 17. Private DNS Resolution

![17_Private_DNS_NSLookup](screenshots/17_Private_DNS_NSLookup.png)

---

### 18. VPC Flow Logs Configuration

![18_VPC_Flow_Logs](screenshots/18_VPC_Flow_Logs.png)

---

### 19. Flow Logs – REJECT Traffic

![19_Flow_Logs_REJECT](screenshots/19_Flow_Logs_REJECT.png)

---

### 20. Flow Logs – ACCEPT Traffic

![20_Flow_Logs_ACCEPT](screenshots/20_Flow_Logs_ACCEPT.png)

---

### 21. AWS VPC Resource Map

![21_AWS_VPC_Resource_Map](screenshots/21_AWS_VPC_Resource_Map.png)

---

## Where I Got Stuck

`No blocker`

---

## Cleanup

**Cleanup (in order):**

1. Terminate the Day 6 EC2 instances.
2. Delete the Interface Endpoint.
3. Delete NAT-A and wait for deletion.
4. Release the Elastic IP.
5. Delete the S3 Gateway Endpoint if not needed.
6. Delete the VPC Flow Log.
7. Delete the dedicated CloudWatch log group if not needed.
8. Restore the original NACL association.
9. Delete the custom NACL.
10. Remove temporary route tables and Security Groups.

---

## LinkedIn Post
[LinkedIn Link](https://www.linkedin.com/posts/activity-7486273013462544386-wPFP?utm_source=share&utm_medium=member_desktop&rcm=ACoAAEJuHJYBII9imgLntyUMaz684Imwl2w4XOM)