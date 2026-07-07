# Day 3 - Account Security Lab

Goal: Create a safe AWS account foundation for the next 10 weeks.

## Before You Start

You need:

- AWS account login
- Mobile phone for MFA app
- Access to your email

If you do not have an AWS account yet then create it : https://aws.amazon.com/

## Lab 1 - Secure Root User

Steps:

1. Create or log in to your AWS account.
2. Search for `IAM` in the AWS Console.
3. Open security recommendations or MFA settings.
4. Enable MFA on the root user.
5. Stop using root user for daily work.
6. Create an IAM admin user only if needed for regular work.

Deliverables:

- Screenshot of root MFA enabled.
- Short note explaining why root user should not be used daily.

## Lab 2 - Billing Alert

Steps:

1. Open AWS Billing Dashboard.
2. Open Budgets.
3. Create a cost budget, for example `$5`.
4. Confirm the alert email or budget setup.

Deliverables:

- Screenshot of billing alert or budget alert.
- Short note explaining why billing should be monitored from Day 1.

## If You Get Stuck

- Add a screenshot of where you got stuck.
- Write 2-3 lines explaining the issue.
- Ask in the community instead of skipping the whole week.

## Safety Note

Do not share:

- Root email
- AWS account ID, if you are not comfortable
- Access keys or secret keys
- MFA QR code
- Payment details
- Detailed billing information
