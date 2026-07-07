# #10WeeksOfAWS Submission Guide

Use this guide every week.

## Weekly Flow

1. Read the current week's README.
2. Complete the hands-on labs in your own AWS account.
3. Add your proof of work in your fork.
4. Open a pull request for that week.
5. Post your progress on LinkedIn and tag the community.
6. Clean up AWS resources to avoid billing surprises.

## Folder Format

Use this structure:

```text
week-XX/submissions/YOUR-NAME/
├── README.md
├── notes.md
├── screenshots/
└── code-or-policies/
```

Example for Week 1:

```text
week-01/submissions/gangadhar-ure/
├── README.md
├── notes.md
├── screenshots/
│   ├── root-mfa.png
│   └── billing-alert.png
└── code-or-policies/
    └── custom-s3-readonly-policy.json
```

## README Template

```markdown
# Week XX Submission - Your Name

## Tasks Completed
- [ ] Watched/read the weekly content
- [ ] Completed hands-on labs
- [ ] Added screenshots or proof
- [ ] Posted on LinkedIn
- [ ] Cleaned up AWS resources

## What I Built
Write 3-5 lines about what you created or configured.

## What I Learned
Write the most important concept you understood this week.

## Screenshots
List the screenshots you added.

## LinkedIn Post
Add your LinkedIn post link here.
```

## Pull Request Format

PR title:

```text
Week XX Submission - Your Name
```

PR description:

```markdown
## Week
Week XX

## Checklist
- [ ] Hands-on completed
- [ ] Screenshots added
- [ ] Notes added
- [ ] LinkedIn post added
- [ ] Cleanup completed
```

## Safety Rules

- Do not commit AWS access keys or secret keys.
- Do not share MFA QR codes.
- Hide account IDs, billing details, and email addresses if needed.
- Delete test resources after each week.
- Keep billing alerts enabled.
