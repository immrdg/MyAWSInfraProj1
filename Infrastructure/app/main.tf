terraform {
  required_version = ">= 1.0"
  backend "local" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "immrdg21"
}

# S3 Bucket Module
module "s3_bucket" {
  source = "../modules/s3"

  bucket_name     = "${var.project_name}-bucket-${var.environment}"
  environment     = var.environment
  enable_versioning = var.enable_versioning
  common_tags     = var.common_tags
}
