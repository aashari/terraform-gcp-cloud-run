---
name: Bug report
about: Create a report to help us improve
title: "[BUG] "
labels: bug
assignees: ""
---

## Bug Description

A clear and concise description of what the bug is.

## Terraform and Provider Versions

- Terraform version: [e.g., v1.11.1]
- Google Provider version: [e.g., v6.24.0]

## Module Version

Which version of the module are you using? [e.g., v1.1.1]

## Reproduction Steps

Steps to reproduce the behavior:

1. Configure module with '...'
2. Run `terraform apply`
3. See error

## Expected Behavior

A clear and concise description of what you expected to happen.

## Actual Behavior

What actually happened, including error messages and logs if available.

## Configuration

```hcl
# Include your module configuration here
module "cloud_run" {
  source = "github.com/aashari/terraform-gcp-cloud-run?ref=v1.1.1"

  # Your configuration...
}
```

## Environment

- OS: [e.g., macOS, Linux, Windows]
- GCP Project: [e.g., production, development]
- GCP Region: [e.g., us-central1]

## Additional Context

Add any other context about the problem here.
