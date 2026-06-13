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
  environment       = "dev"
  aws_region        = "us-east-1"
  profile           = "immrdg21"
  enable_versioning = false

  common_tags = merge(
    include.root.inputs.common_tags,
    local.environment_tags
  )
}
