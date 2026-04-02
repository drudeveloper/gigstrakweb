variable "project_name" {
  description = "Short project identifier used in resource naming."
  type        = string
  default     = "gigstrak"
}

variable "aws_region" {
  description = "Primary AWS region for the S3 bucket and IAM resources."
  type        = string
  default     = "us-west-2"
}

variable "root_domain_name" {
  description = "Apex domain already hosted in Route 53, such as gigstrak.com."
  type        = string
}

variable "site_subdomain" {
  description = "Subdomain to serve from CloudFront, such as www."
  type        = string
  default     = "www"
}

variable "github_org" {
  description = "GitHub organization or user that owns the repository."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name."
  type        = string
}

variable "github_branch" {
  description = "Git branch allowed to deploy through GitHub Actions OIDC."
  type        = string
  default     = "main"
}

variable "create_github_oidc_provider" {
  description = "Create the GitHub Actions OIDC provider in this AWS account. Set to false if it already exists."
  type        = bool
  default     = false
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "tags" {
  description = "Tags applied to all supported resources."
  type        = map(string)
  default     = {}
}
