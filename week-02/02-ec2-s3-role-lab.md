# Day 3 Practical - EC2 Reads S3 Using an IAM Role

Goal: Let an EC2 instance read from one test S3 bucket without storing access
keys. Confirm that reading is allowed and writing is denied.

## Architecture

```text
EC2 instance
  -> instance profile
  -> IAM role
  -> STS temporary credentials
  -> allowed: list/read one S3 bucket
  -> denied: upload/delete objects
```

## Cost and Safety

- Use a small Free Tier-eligible instance type where available.
- Use a test bucket with no sensitive data.
- Do not create IAM user access keys.
- Do not display or share temporary credentials.
- Complete [03-cleanup.md](./03-cleanup.md) when finished.

## Step 1 - Create a Test S3 Bucket

1. Open the S3 console and create a bucket with a globally unique name.
2. Keep Block Public Access enabled.
3. Upload a small file named `day3-test.txt`.
4. Put a short non-sensitive message inside the file.

Save your bucket name. The examples below use `YOUR-BUCKET-NAME`.

## Step 2 - Create the EC2 Role

1. Open IAM -> Roles -> Create role.
2. Select **AWS service** as the trusted entity.
3. Select **EC2** as the use case.
4. Name the role `Week2Day3EC2S3ReadRole`.
5. Do not attach broad S3 permissions.

Confirm that its trust policy allows the `ec2.amazonaws.com` service principal
to call `sts:AssumeRole`.

## Step 3 - Add Least-Privilege S3 Permissions

Create an inline policy named `ReadOneTrainingBucket` and replace both instances
of `YOUR-BUCKET-NAME`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListOneBucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME"
    },
    {
      "Sid": "ReadObjectsInOneBucket",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::YOUR-BUCKET-NAME/*"
    }
  ]
}
```

Notice what is missing: `s3:PutObject`, `s3:DeleteObject`, and wildcard S3
permissions.

## Step 4 - Launch and Attach the Role to EC2

1. Launch one small Amazon Linux EC2 instance.
2. Under **Advanced details**, choose
   `Week2Day3EC2S3ReadRole` for the IAM instance profile.
3. Use EC2 Instance Connect or Session Manager if it is available in your
   setup. If you use SSH, restrict inbound access to your own IP.
4. Wait for the instance status checks to pass.

If the instance already exists, use **Actions -> Security -> Modify IAM role**
and attach the role.

## Step 5 - Test Allowed Access

On the EC2 instance, confirm that no credentials were manually configured:

```bash
aws configure list
```

Then test the allowed actions:

```bash
aws sts get-caller-identity
aws s3 ls s3://YOUR-BUCKET-NAME
aws s3 cp s3://YOUR-BUCKET-NAME/day3-test.txt -
```

Expected result:

- The caller identity shows an assumed-role identity.
- The bucket can be listed.
- The test object can be read.

## Step 6 - Test Denied Access

Try to upload a harmless test object:

```bash
printf 'write test\n' > /tmp/write-test.txt
aws s3 cp /tmp/write-test.txt s3://YOUR-BUCKET-NAME/write-test.txt
```

Expected result: `AccessDenied`, because the permission policy does not allow
`s3:PutObject`.

Do not add write access just to make this command succeed. The denied result is
proof that least privilege is working.

## Step 7 - Collect Safe Proof

Capture:

- Role trust policy with account-sensitive details hidden if necessary
- Inline permission policy
- Role attached to the EC2 instance
- Successful `get-caller-identity`, with account ID hidden
- Successful S3 list or read
- Denied S3 write

Never share an access key ID, secret access key, session token, private key, or
private data.

## Troubleshooting

- `Unable to locate credentials`: confirm the IAM role is attached to the
  instance, then retry after a short wait.
- `AccessDenied` while reading: check the bucket name, object key, action, and
  both bucket and object ARNs in the permission policy.
- Wrong caller identity: make sure no environment variables or AWS CLI profile
  are overriding the instance role.
- Upload succeeds unexpectedly: inspect all policies attached to the role and
  remove permissions that are broader than the lab requires.
