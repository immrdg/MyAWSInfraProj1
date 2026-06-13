include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../..//app"
}

inputs = {
  environment       = "dev"
  aws_region        = "us-east-1"
  enable_versioning = false

  common_tags = merge(
    include.root.inputs.common_tags,
    {
      Environment = "dev"
    }
  )
}
