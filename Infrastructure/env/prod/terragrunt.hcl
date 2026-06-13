include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "../../..//Infrastructure/app"
}

locals {
  environment_tags = {
    Environment = "prod"
  }
}

inputs = {
  environment              = "prod"
  aws_region               = "us-east-1"
  profile                  = "immrdg21"
  project_name             = "private-api"
  
  # Lambda configuration
  lambda_zip_file_path     = "${get_repo_root()}/lambda/rest-api/lambda-function.zip"
  lambda_handler           = "handler.lambda_handler"
  lambda_runtime           = "python3.11"
  lambda_timeout           = 60
  lambda_memory_size       = 256
  lambda_environment_variables = {
    ENVIRONMENT = "prod"
  }
  log_retention_days       = 30

  common_tags = merge(
    include.root.inputs.common_tags,
    local.environment_tags
  )
}

