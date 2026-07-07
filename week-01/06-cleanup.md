# Week 1 Cleanup

Clean up test resources after completing the labs.

## Why Cleanup Matters

Cleanup is part of the challenge. It protects you from surprise AWS bills.

## Delete Test IAM Resources

Delete these if you created them only for practice:

- `learner-s3`
- `learner-ec2`
- `learner-billing`
- `S3ReadOnlyGroup`
- `EC2ReadOnlyGroup`
- `BillingViewGroup`
- `CustomS3ReadOnlyTrainingPolicy`
- `TrainingReadOnlyRole`
- `github-oidc-challenge-role`

## Keep These Enabled

Do not delete:

- Root MFA
- Billing or budget alerts
- Your main safe admin setup

## Final Check

Before closing the week:

- No access keys are shared publicly.
- No secret keys are committed to GitHub.
- Screenshots hide sensitive details.
- Test users and roles are removed if no longer needed.

If you are unsure whether something is safe to delete, ask before deleting it.
