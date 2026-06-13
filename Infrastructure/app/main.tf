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
  region  = var.aws_region
  profile = "immrdg21"
}

# Project Module - Orchestrates Lambda and supporting resources
module "project" {
  source = "../modules/project"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_subnet_cidrs     = var.private_subnet_cidrs
  lambda_zip_file_path     = var.lambda_zip_file_path
  lambda_handler           = var.lambda_handler
  lambda_runtime           = var.lambda_runtime
  lambda_timeout           = var.lambda_timeout
  lambda_memory_size       = var.lambda_memory_size
  lambda_environment_variables = var.lambda_environment_variables
  log_retention_days       = var.log_retention_days
  common_tags              = var.common_tags
}

