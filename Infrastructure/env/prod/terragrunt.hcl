include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//app"
}

inputs = {
  environment       = "prod"
  aws_region        = "us-east-1"
  enable_versioning = true

  common_tags = merge(
    include.root.inputs.common_tags,
    {
      Environment = "prod"
    }
  )
}
