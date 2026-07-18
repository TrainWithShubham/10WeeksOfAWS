# Week 2 - Day 3: IAM Roles and STS

## Name
Shashank Nadankar

## Topics Practiced
- Trust policy vs permission policy
- STS AssumeRole
- EC2 role and instance profile
- Cross-service role assumption
- Temporary credentials
- Least-privilege S3 access

## What I Built
I created an IAM role which had a policy attached which allowed to READ and LIST objects from the S3 buckets. I attached this IAM role to the EC2 instance to be able to get objects from the EC2 instance without storing
access key on the Server.

## Allowed Test
The role attached to the EC2 instance will only allow to LIST and GET objects from the s3 bucket. When the IAM role was attached to the EC2 instance we saw that we were able to list the file which were present inside the S3 bucket.
We also downloaded the file from s3 to our server.

## Denied Test
The attached Role only allowed the EC2 instance to list and get the objects inside the S3 bucket. When we tried to upload file to the s3 bucket. It throwed error saying "Access Denied". As the policy attached to the IAM role only
allowed the entity to the LIST and GET the objects from S3 and not Write to it.

## What I Learned
The Trust policy is attached to an IAM role. It answers who is allowed to assume this role. Here in our test, we allowed the EC2 to assume this role. But this Trust Policy doesn't give EC2 permission to S3 bucket.
The Permission policy answer, Once someone assume the role, What they are allowed to do. The role here is allowed to read from s3.

The complete flow

EC2
|
IAM Role
|
S3

EC2 wants the role. AWS checks in the Trust Policy if the EC2 is allowed to Assume the role? If yes then STS issues temporary credentials.

Now when ec2 tries to call S3. AWS checks does this role allow to list S3 buckets? If yes then it granted.  

You can check the details about the STS session using the below steps


1.  First get the IMDSv2 token

      $TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \/
        -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")


2. Get the role name
   
  curl -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/iam/security-credentials/


3.  Now retrieve the credentials
   
     curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/iam/security-credentials/EC2-Instance-Role
    

This will return a JSON which contains the temporary security credentails returned by AWS STS.

It contains details regarding the connection, like accessID, expiratioon time etc.

## Where I Got Stuck
No Blocker

## Cleanup
After the Lab completed I deleted the AWS Resources which were created, EC2 Instance, S3 bucket, IAM role, IAM Policy

