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
  environment       = "prod"
  aws_region        = "us-east-1"
  enable_versioning = true
  profile           = "immrdg21"

  common_tags = merge(
    include.root.inputs.common_tags,
    local.environment_tags
  )
}
