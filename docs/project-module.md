# Project Module

This is the main orchestration module that creates the complete REST API Lambda project stack.

## What It Creates

### 1. S3 Bucket for Lambda Artifacts
- Versioning enabled
- Server-side encryption
- Public access blocked
- Used for storing Lambda deployment packages

### 2. Lambda Function Stack
- **Lambda Function** - REST API function for handling employee requests
- **IAM Role** - Execution role with CloudWatch Logs permissions
- **CloudWatch Log Group** - For function logs with configurable retention

## Architecture

```
Project Module
├── S3 Module (Lambda Artifacts)
│   ├── S3 Bucket
│   ├── Versioning Configuration
│   ├── Encryption Configuration
│   └── Public Access Block
└── Lambda Module (REST API Function)
    ├── Lambda Function
    ├── IAM Role
    ├── IAM Policy Attachment (Basic Execution)
    └── CloudWatch Log Group
```

## Usage

```hcl
module "project" {
  source = "../modules/project"

  project_name           = "private-api"
  environment            = "dev"
  lambda_zip_file_path   = "../lambda/rest-api/lambda-function.zip"
  lambda_handler         = "handler.lambda_handler"
  lambda_runtime         = "python3.11"
  lambda_timeout         = 30
  lambda_memory_size     = 128
  lambda_environment_variables = {
    ENVIRONMENT = "dev"
  }
  log_retention_days     = 14

  common_tags = {
    Project     = "PrivateAPI"
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Variables

### Required
- `project_name` - Project name (used as prefix for all resources)
- `environment` - Environment name (dev, staging, prod, etc.)
- `lambda_zip_file_path` - Path to the Lambda function zip file

### Optional with Defaults
- `lambda_handler` - Handler function (default: handler.lambda_handler)
- `lambda_runtime` - Runtime (default: python3.11)
- `lambda_timeout` - Timeout in seconds (default: 30)
- `lambda_memory_size` - Memory in MB (default: 128)
- `lambda_environment_variables` - Environment variables (default: {})
- `log_retention_days` - Log retention (default: 14)
- `common_tags` - Resource tags (default: Terraform and ManagedBy tags)

## Outputs

### Lambda Outputs
- `lambda_function_arn` - ARN of the Lambda function
- `lambda_function_name` - Name of the Lambda function
- `lambda_invoke_arn` - Invoke ARN for API Gateway/other services
- `lambda_role_arn` - ARN of the Lambda execution role

### S3 Outputs
- `s3_artifacts_bucket_id` - S3 bucket ID for Lambda artifacts
- `s3_artifacts_bucket_arn` - ARN of the S3 bucket

### CloudWatch Outputs
- `cloudwatch_log_group_name` - Log group name
- `cloudwatch_log_group_arn` - Log group ARN

## Deployment Example

In your app/main.tf:

```hcl
module "project" {
  source = "../modules/project"

  project_name         = var.project_name
  environment          = var.environment
  lambda_zip_file_path = var.lambda_zip_file_path
  # ... other variables ...
  common_tags          = var.common_tags
}
```

Then in your environment variables file (e.g., dev.tfvars):

```hcl
project_name         = "private-api"
environment          = "dev"
lambda_zip_file_path = "../../lambda/rest-api/lambda-function.zip"
log_retention_days   = 7

common_tags = {
  Project     = "PrivateAPI"
  Environment = "dev"
  Terraform   = "true"
}
```

## Notes

- The Lambda function requires a zip file. Build it with `make build` in the lambda/rest-api directory
- IAM role includes only basic execution permissions for CloudWatch Logs
- Additional permissions can be added by extending the module
- S3 bucket is created with encryption and public access disabled by default
