# AWS Static Hosting Setup

This repo is configured to deploy the site to `S3 + CloudFront` from GitHub Actions.

Terraform for the AWS resources is included in:

- `terraform/`

There is a separate Terraform guide at:

- `docs/terraform-aws-setup.md`

## What the pipeline does

- Builds a static version of the site with `scripts/build-static-site.ps1`
- Uploads the generated files from `build/static-site`
- Invalidates the CloudFront cache after deploy

The workflow file is:

- `.github/workflows/deploy-static-site.yml`

## 1. Create the S3 bucket

Create a bucket for the site contents. Typical naming:

- `www.yourdomain.com`

Recommended settings:

- Keep `Block all public access` enabled
- Do not use the bucket website endpoint
- Let CloudFront access the bucket privately with Origin Access Control

## 2. Create the CloudFront distribution

Create a distribution with:

- Origin: your S3 bucket
- Origin Access: `Origin Access Control (OAC)`
- Default root object: `index.html`
- Viewer protocol policy: `Redirect HTTP to HTTPS`

For clean URLs like `/about/` and `/privacy/`, attach a CloudFront Function on `Viewer request`.

Function source:

- `infra/cloudfront-url-rewrite.js`

This rewrites:

- `/about` -> `/about/index.html`
- `/about/` -> `/about/index.html`
- `/` -> `/index.html`

Do not use SPA-style fallback rewrites for this site. It is a multi-page site, so unknown paths should remain unknown.

## 3. Attach your domain

Use:

- `Route 53` for DNS
- `AWS Certificate Manager` for TLS

Steps:

1. Request a certificate in `us-east-1`
2. Validate the certificate
3. Attach it to the CloudFront distribution
4. Point your domain to CloudFront from Route 53

## 4. Create the GitHub Actions IAM role

Use GitHub OIDC instead of long-lived AWS keys.

Create an IAM role trusted by GitHub's OIDC provider.

### Trust policy

Replace:

- `YOUR_GITHUB_ORG`
- `YOUR_GITHUB_REPO`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_GITHUB_ORG/YOUR_GITHUB_REPO:*"
        }
      }
    }
  ]
}
```

### Permissions policy

Replace:

- `YOUR_BUCKET_NAME`
- `YOUR_CLOUDFRONT_DISTRIBUTION_ID`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::YOUR_BUCKET_NAME",
        "arn:aws:s3:::YOUR_BUCKET_NAME/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Resource": "*"
    }
  ]
}
```

## 5. Add GitHub repository variables

In GitHub, go to:

- `Settings`
- `Secrets and variables`
- `Actions`
- `Variables`

Create these repository variables:

- `AWS_REGION`
- `AWS_ROLE_ARN`
- `S3_BUCKET`
- `CLOUDFRONT_DISTRIBUTION_ID`

Example values:

- `AWS_REGION=us-west-2`
- `AWS_ROLE_ARN=arn:aws:iam::<account-id>:role/github-gigstrak-deploy`
- `S3_BUCKET=www.yourdomain.com`
- `CLOUDFRONT_DISTRIBUTION_ID=E1234567890ABC`

## 6. Push to deploy

The workflow deploys on pushes to:

- `main`

You can also run it manually from:

- `Actions`
- `Deploy Static Site`
- `Run workflow`

## 7. Local build check

Generate the deployable static site locally:

```powershell
./scripts/build-static-site.ps1
```

Output:

- `build/static-site`

## Notes

- The current Play Store link points to the general Play Store URL. Replace it with the app listing URL when you have it.
- The Apple badge is currently a coming-soon asset, not an App Store listing link.
- Clean subpage URLs rely on the CloudFront Function in `infra/cloudfront-url-rewrite.js`.
