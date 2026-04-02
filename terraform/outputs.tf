output "site_bucket_name" {
  description = "S3 bucket receiving static site deploys."
  value       = aws_s3_bucket.site.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID used by GitHub Actions for cache invalidation."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "github_deploy_role_arn" {
  description = "IAM role ARN to place in the GitHub Actions AWS_ROLE_ARN variable."
  value       = aws_iam_role.github_deploy.arn
}

output "github_actions_variables" {
  description = "GitHub repository variable values required by the deploy workflow."
  value = {
    AWS_REGION               = var.aws_region
    AWS_ROLE_ARN             = aws_iam_role.github_deploy.arn
    S3_BUCKET                = aws_s3_bucket.site.bucket
    CLOUDFRONT_DISTRIBUTION_ID = aws_cloudfront_distribution.site.id
  }
}

output "site_urls" {
  description = "Primary site URLs."
  value = {
    apex = "https://${var.root_domain_name}"
    site = "https://${local.site_domain}"
  }
}
