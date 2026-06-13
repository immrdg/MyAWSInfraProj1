# Root terragrunt configuration
# This file defines common settings for all environments
# Run from project root: terragrunt plan --terragrunt-working-dir Infrastructure/env/dev

locals {
  aws_region = "us-east-1"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terragrunt-state-${get_aws_account_id()}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    dynamodb_table = "terragrunt-locks"
  }
}

# Generate provider blocks
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
      }
    }

    provider "aws" {
      region = var.aws_region
      
      default_tags {
        tags = var.common_tags
      }
    }
  EOF
}

# Common inputs for all environments
inputs = {
  project_name = "myproject"
  common_tags = {
    Terraform = "true"
    ManagedBy = "Terragrunt"
  }
}
