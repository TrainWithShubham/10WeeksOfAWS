# Day 11 Lab - Private, Versioned, and Protected Amazon S3


## Name
Sanket Dangat

## Tasks Completed
- [x] Watched/read the weekly content
- [x] Completed hands-on labs
- [x] Added screenshots or proof
- [X] Posted on LinkedIn
- [x] Cleaned up AWS resources


## Architecture

![Architecture](diagram/day11-architecture-diagram.png)


## Result

Successfully implemented a private, versioned, encrypted, and protected Amazon S3 workflow. Verified private bucket access, S3 Versioning and recovery from a delete marker, manual bucket-to-bucket object copy with independent destination encryption, SSE-KMS with S3 Bucket Key, presigned URL access, Lifecycle Management, and S3 Object Lock Legal Hold protection.

**Resources created:**

- Source Bucket `cloudadhar-s3-day11-sanketd-<unique-suffix>`
- Destination Bucket `cloudadhar-s3-day11-copy-sanketd-<unique-suffix>`
- Object Lock Bucket `cloudadhar-s3-day11-lock--sanketd-<unique-suffix>`
- Customer Managed KMS Key `alias/cloudadhar-s3-day11`
- Lifecycle Rule `logs-transition-and-cleanup`
- S3 prefixes `documents/`, `versions/`, `logs/`, `storage/`, and `presigned/`

**Validation:** Successfully verified that all buckets remained private with Block Public Access enabled, Versioning protected objects from normal deletion, the destination copy became an independent SSE-KMS encrypted object, normal Object URLs were denied while short-lived presigned URLs worked, Lifecycle Management was configured for future transitions and cleanup, and Legal Hold prevented permanent deletion until the hold was removed.

### 1. Customer Managed KMS Key

Created the customer managed KMS key `alias/cloudadhar-s3-day11` in the Mumbai region with symmetric encryption and decrypt usage. Verified that the key was enabled.

![KMS Key Created](./screenshots/01-kms-key-created.png)

---

### 2. Private Source Bucket

Created the source bucket `cloudadhar-s3-day11-<unique-suffix>` in `ap-south-1` with Bucket owner enforced, ACLs disabled, all four Block Public Access settings enabled, Versioning enabled, and SSE-S3 default encryption.

![Source Bucket Properties](./screenshots/02-source-bucket-properties.png)

![Source Bucket Block Public Access](./screenshots/03-source-bucket-block-public-access.png)

---

### 3. SSE-KMS Destination Bucket

Created the destination bucket `cloudadhar-s3-day11-copy-sanketd-<unique-suffix>` with Bucket owner enforced, all four Block Public Access settings enabled, Versioning enabled, SSE-KMS default encryption using `alias/cloudadhar-s3-day11`, and S3 Bucket Key enabled.

![Destination Bucket SSE-KMS](./screenshots/04-destination-bucket-sse-kms.png)

---

### 4. S3 Prefixes and Storage Classes

Created the required S3 prefixes:

- `documents/`
- `versions/`
- `logs/`
- `storage/`
- `presigned/`

Uploaded the required demonstration objects and verified their storage classes, including `standard-demo.txt` using S3 Standard and `intelligent-tiering-demo.txt` using S3 Intelligent-Tiering.

![S3 Prefixes](./screenshots/05-s3-prefixes.png)

![Storage Class Verification](./screenshots/06-storage-class-verification.png)

---

### 5. Version 1 Upload

Uploaded `version-demo.txt` containing Version 1 under the S3 key `versions/version-demo.txt`.

**Version ID:** Recorded and verified in the S3 console.

![Version 1 Created](./screenshots/07-version-1-created.png)

---

### 6. Version 2 Upload

Uploaded Version 2 using the same S3 object key `versions/version-demo.txt`.

Enabled **Show versions** and verified that two independent data versions existed with different Version IDs, with Version 2 as the current version.

![Version 1 and Version 2](./screenshots/08-version-1-and-version-2.png)

---

### 7. Delete Marker and Version Recovery

Deleted `version-demo.txt` normally and verified that the object disappeared from the standard object listing.

Enabled **Show versions**, identified the delete marker, and permanently deleted only the delete marker.

Verified that the previous Version 2 data became the current object again.

![Delete Marker Created](./screenshots/09-delete-marker-created.png)

![Version 2 Recovered](./screenshots/10-version-2-recovered.png)

---

### 8. Bucket-to-Bucket Object Copy

Copied `documents/private-report.txt` from the source bucket to the destination bucket under the `copied/` prefix.

Verified that `copied/private-report.txt` was created as an independent destination object with its own Version ID and uses the destination bucket's SSE-KMS encryption with the Day 11 customer managed KMS key.

![Copied Private Report](./screenshots/11-copied-private-report.png)

![Copied Object SSE-KMS](./screenshots/12-copied-object-sse-kms.png)

---

### 9. Private Object Access

Opened the normal S3 Object URL for `private-report.txt` from an incognito/private browser window.

Verified that anonymous access was denied with **AccessDenied** while Block Public Access remained enabled.

![Normal Object URL Access Denied](./screenshots/13-normal-object-url-access-denied.png)

---

### 10. Block Public Access Protection

Performed a controlled public-read policy test while keeping all four Block Public Access controls enabled.

Verified that S3 rejected or prevented the policy from granting public access and confirmed that no public policy remained afterward.

![Block Public Access Policy Rejected](./screenshots/14-block-public-access-policy-rejected.png)

---

### 11. Presigned URL Validation

Generated a short-lived 60-second presigned GET URL for `documents/private-report.txt`.

Verified that the object could be accessed through the presigned URL from an incognito/private window while the normal Object URL remained inaccessible with `AccessDenied`.

After the expiry period, refreshed the presigned URL and verified that it was no longer valid and access was denied.

![Presigned URL Success](./screenshots/15-presigned-url-success.png)

![Expired Presigned URL](./screenshots/16-presigned-url-expired.png)

![Normal URL Still Denied](./screenshots/17-normal-url-still-denied.png)
 
---

### 12. Lifecycle Management

Created the Lifecycle Rule `logs-transition-and-cleanup` scoped only to the `logs/` prefix.

Configured current-version transitions to Standard-IA after 30 days, Glacier Flexible Retrieval after 90 days, and expiration after 365 days.

Configured noncurrent-version transition to Standard-IA after 30 days and permanent deletion after 90 days, along with incomplete multipart-upload cleanup after 7 days.


![Lifecycle Rule Overview](./screenshots/18-lifecycle-rule-overview.png)

---

### 13. Object Lock Bucket

Created the separate Object Lock bucket `cloudadhar-s3-day11-lock--sanketd-<unique-suffix>` with Bucket owner enforced, ACLs disabled, all Block Public Access settings enabled, Versioning enabled, and Object Lock enabled.

No default Compliance-mode retention was configured.

![Object Lock Bucket Created](./screenshots/19-object-lock-bucket-created.png)

---

### 14. Legal Hold Applied

Uploaded `retention-demo.txt` into the `lock/` prefix and enabled **Legal Hold** on the specific object version.

![Legal Hold Enabled](./screenshots/20-legal-hold-enabled.png)

---

### 15. Legal Hold Prevents Deletion

Attempted to permanently delete the protected object version while Legal Hold was enabled.

Verified that the deletion was denied because the object version was protected by Legal Hold.

![Legal Hold Deletion Denied](./screenshots/21-legal-hold-deletion-denied.png)

---

### 16. Legal Hold Removed and Cleanup

Removed the Legal Hold from the object version and permanently deleted the exact version.

Verified that deletion succeeded after the Legal Hold was removed and no retention period protected the object.

![Legal Hold Removed and Object Version Deleted](./screenshots/22-legal-hold-disabled-and-object-deleted.png)

---

## Cleanup

**S3 resource cleanup (in order):**

1. Removed the Lifecycle Rule `logs-transition-and-cleanup`
2. Removed all demonstration objects and object versions from the source bucket, including any remaining delete markers
3. Removed all demonstration objects and object versions from the destination bucket, including `copied/private-report.txt`
4. Removed `retention-demo.txt` and its object version from the Object Lock bucket after removing the Legal Hold
5. Deleted the Object Lock bucket `cloudadhar-s3-day11-lock--sankted-<unique-suffix>`
6. Deleted the destination bucket `cloudadhar-s3-day11-copy-sankted-<unique-suffix>`
7. Deleted the source bucket `cloudadhar-s3-day11-sankted-<unique-suffix>`
8. Verified that no Day 11 S3 buckets, objects, lifecycle rules

---

## LinkedIn Post

[LinkedIn Link] (https://lnkd.in/p/dE88ersB)