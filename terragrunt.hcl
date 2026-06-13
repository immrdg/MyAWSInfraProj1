# Root terragrunt configuration
# This file defines common settings for all environments
# Run from project root: terragrunt plan --terragrunt-working-dir Infrastructure/env/dev

locals {
  aws_region = "us-east-1"
}

remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# Common inputs for all environments
inputs = {
  project_name = "dgproject"
  common_tags = {
    Terraform = "true"
    ManagedBy = "Terragrunt"
  }
}
