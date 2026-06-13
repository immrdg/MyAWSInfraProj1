variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, staging, etc.)"
  type        = string
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    ManagedBy   = "Terragrunt"
  }
}
