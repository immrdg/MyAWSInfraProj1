terraform {
  required_version = ">= 1.0"
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

# S3 Bucket Module
module "s3_bucket" {
  source = "../modules/s3"

  bucket_name     = "${var.project_name}-bucket-${var.environment}"
  environment     = var.environment
  enable_versioning = var.enable_versioning
  common_tags     = var.common_tags
}
