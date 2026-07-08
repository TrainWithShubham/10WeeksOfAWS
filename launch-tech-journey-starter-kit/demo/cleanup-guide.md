# Cleanup Guide

This demo creates an AWS EC2 instance. To avoid AWS charges, destroy resources after the demo.

## Option 1: Local destroy

```bash
cd terraform
terraform destroy -auto-approve
```

## Option 2: GitHub Actions destroy

Go to GitHub → Actions → Terraform EC2 Demo → Run workflow → choose `destroy`.

## Check cleanup

Go to AWS Console:

- EC2 instance should be terminated
- Security group should be deleted

