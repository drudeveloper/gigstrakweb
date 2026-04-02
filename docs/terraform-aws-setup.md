# Terraform AWS Setup

This repo includes Terraform to provision the AWS infrastructure for:

- private S3 bucket for site assets
- CloudFront distribution with custom domain support
- ACM certificate in `us-east-1`
- Route 53 DNS records for apex and subdomain
- CloudFront Function for clean URL rewrites
- GitHub Actions OIDC IAM role for CI/CD deploys

Terraform files live in:

- `terraform/`

## Required inputs

Copy:

- `terraform/terraform.tfvars.example`

to:

- `terraform/terraform.tfvars`

Then replace the placeholders.

## Expected domain model

The Terraform stack assumes:

- Route 53 already hosts your apex zone, such as `gigstrak.com`
- the site is served from both:
  - `gigstrak.com`
  - `www.gigstrak.com`

## Commands

From the repo root:

```powershell
cd terraform
terraform init
terraform plan
terraform apply
```

## Important notes

- ACM for CloudFront must live in `us-east-1`; Terraform handles that with a provider alias.
- If your AWS account already has the GitHub OIDC provider, keep `create_github_oidc_provider = false`.
- If not, set it to `true` for the first apply.

## After apply

Take the Terraform outputs and set these GitHub repository variables:

- `AWS_REGION`
- `AWS_ROLE_ARN`
- `S3_BUCKET`
- `CLOUDFRONT_DISTRIBUTION_ID`

Those map directly to the workflow in:

- `.github/workflows/deploy-static-site.yml`

## Deploy flow

1. Terraform provisions the AWS infrastructure.
2. You add the output values to GitHub repository variables.
3. Push to `main`.
4. GitHub Actions builds the static site and deploys it to S3.
5. CloudFront invalidates the cache.
