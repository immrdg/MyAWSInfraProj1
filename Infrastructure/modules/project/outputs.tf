output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}


output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.vpc.internet_gateway_id
}

output "lambda_function_arn" {
  description = "ARN of the REST API Lambda function"
  value       = module.rest_api_lambda.lambda_function_arn
}

output "lambda_function_name" {
  description = "Name of the REST API Lambda function"
  value       = module.rest_api_lambda.lambda_function_name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the REST API Lambda function"
  value       = module.rest_api_lambda.lambda_function_invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = module.rest_api_lambda.lambda_role_arn
}

output "s3_artifacts_bucket_id" {
  description = "S3 bucket for Lambda artifacts"
  value       = module.s3_lambda_artifacts.bucket_id
}

output "s3_artifacts_bucket_arn" {
  description = "ARN of the S3 artifacts bucket"
  value       = module.s3_lambda_artifacts.bucket_arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group name for Lambda"
  value       = module.rest_api_lambda.log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = module.rest_api_lambda.log_group_arn
}
