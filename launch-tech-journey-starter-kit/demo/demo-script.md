# Demo Script: Code to Live Website

## Goal
Show students how a real cloud and DevOps workflow works:

**VS Code → GitHub → Automation → Terraform → AWS EC2 → User Data → Live Website**

## What to say before demo

Today I will show you how code becomes a live website using a real cloud workflow.

I will not go deep into every command today. I want you to understand the big picture.

## Demo Steps

### Step 1: Open the repository in VS Code
Show these folders:

- `terraform/`
- `.github/workflows/`
- `roadmaps/`
- `projects/`

Say:

> This repository contains both learning roadmaps and a practical cloud demo.

### Step 2: Explain Terraform files
Open:

- `terraform/main.tf`
- `terraform/user_data.sh`

Say:

> Terraform creates the EC2 server, and User Data installs Apache and creates the website.

### Step 3: Push code to GitHub

```bash
git add .
git commit -m "Update demo website"
git push
```

Say:

> GitHub stores the code and triggers automation.

### Step 4: Run GitHub Actions manually

Go to GitHub → Actions → Terraform EC2 Demo → Run workflow → choose `apply`.

Say:

> The automation now runs Terraform and creates the cloud server.

### Step 5: Open website

After Terraform completes, copy the `website_url` output and open it in browser.

Say:

> This is how real teams deploy code and infrastructure using automation.

## Closing line

This one demo connects programming, GitHub, automation, Terraform, AWS, and web hosting. That is why modern tech skills are connected.
