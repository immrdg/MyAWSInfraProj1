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

  common_tags = merge(
    include.root.inputs.common_tags,
    local.environment_tags
  )
}

