# Project Module - Orchestrates all resources for the REST API Lambda project

# S3 Bucket for Lambda code artifacts
module "s3_lambda_artifacts" {
  source = "../s3"

  bucket_name       = "${var.project_name}-lambda-artifacts-${var.environment}"
  environment       = var.environment
  enable_versioning = true
  common_tags       = var.common_tags
}

# Lambda Function with IAM role and CloudWatch logs
module "rest_api_lambda" {
  source = "../lambda"

  function_name = "${var.project_name}-rest-api-${var.environment}"
  zip_file_path = var.lambda_zip_file_path
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout
  memory_size   = var.lambda_memory_size

  environment_variables = var.lambda_environment_variables
  log_retention_days    = var.log_retention_days
  common_tags           = var.common_tags
}
