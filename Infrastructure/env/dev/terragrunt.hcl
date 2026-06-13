include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "../../..//Infrastructure/app"
}

locals {
  environment_tags = {
    Environment = "dev"
  }
}

inputs = {
  environment              = "dev"
  aws_region               = "us-east-1"
  profile                  = "immrdg21"
  project_name             = "private-api"
  
  # VPC Configuration
  vpc_cidr                 = "10.0.0.0/16"
  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  
  # Lambda configuration
  lambda_zip_file_path     = "${get_repo_root()}/lambda/rest-api/lambda-function.zip"
  lambda_handler           = "handler.lambda_handler"
  lambda_runtime           = "python3.11"
  lambda_timeout           = 30
  lambda_memory_size       = 128
  lambda_environment_variables = {
    ENVIRONMENT = "dev"
  }
  log_retention_days       = 7

  # API Gateway configuration
  api_authorization_type  = "NONE"
  api_cors_allow_origins  = ["*"]
  api_cors_allow_methods  = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
  api_cors_allow_headers  = ["Content-Type", "Authorization", "X-Amz-Date"]

  common_tags = merge(
    include.root.inputs.common_tags,
    local.environment_tags
  )
}

