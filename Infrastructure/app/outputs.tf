output "lambda_function_arn" {
  description = "ARN of the REST API Lambda function"
  value       = module.project.lambda_function_arn
}

output "lambda_function_name" {
  description = "Name of the REST API Lambda function"
  value       = module.project.lambda_function_name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the REST API Lambda function"
  value       = module.project.lambda_invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = module.project.lambda_role_arn
}

output "s3_artifacts_bucket_id" {
  description = "S3 bucket for Lambda artifacts"
  value       = module.project.s3_artifacts_bucket_id
}

output "s3_artifacts_bucket_arn" {
  description = "ARN of the S3 artifacts bucket"
  value       = module.project.s3_artifacts_bucket_arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for Lambda"
  value       = module.project.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = module.project.cloudwatch_log_group_arn
}

# API Gateway outputs
output "api_endpoint" {
  description = "API Gateway endpoint URL"
  value       = module.project.api_endpoint
}

output "api_id" {
  description = "API Gateway ID"
  value       = module.project.api_id
}

output "api_arn" {
  description = "API Gateway ARN"
  value       = module.project.api_arn
}

output "api_log_group_name" {
  description = "API Gateway CloudWatch log group name"
  value       = module.project.api_log_group_name
}

# VPC outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.project.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.project.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.project.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.project.private_subnet_ids
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.project.internet_gateway_id
}

