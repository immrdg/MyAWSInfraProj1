# Project Module - Orchestrates all resources for the REST API Lambda project

# VPC with public and private subnets
module "vpc" {
  source = "../vpc"

  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidrs    = var.public_subnet_cidrs
  private_subnet_cidrs   = var.private_subnet_cidrs
  common_tags            = var.common_tags
}

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

# API Gateway HTTP endpoint
module "api_gateway" {
  source = "../api-gateway"

  api_name             = "${var.project_name}-api"
  environment          = var.environment
  lambda_function_name = module.rest_api_lambda.lambda_function_name
  lambda_invoke_arn    = module.rest_api_lambda.lambda_function_invoke_arn
  authorization_type  = var.api_authorization_type
  cors_allow_origins  = var.api_cors_allow_origins
  cors_allow_methods  = var.api_cors_allow_methods
  cors_allow_headers  = var.api_cors_allow_headers
  log_retention_days  = var.log_retention_days
  common_tags         = var.common_tags
}

