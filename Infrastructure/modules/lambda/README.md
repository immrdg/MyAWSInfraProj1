# Lambda Module

This module creates a complete Lambda function setup including:

- **AWS Lambda Function** - The compute resource
- **IAM Role** - Execution role with basic Lambda execution permissions
- **CloudWatch Log Group** - For Lambda function logs

## Usage

```hcl
module "lambda" {
  source = "../modules/lambda"

  function_name = "my-function"
  zip_file_path = "/path/to/function.zip"
  handler       = "handler.lambda_handler"
  runtime       = "python3.11"
  timeout       = 30
  memory_size   = 128

  environment_variables = {
    ENV = "production"
  }

  common_tags = {
    Terraform = "true"
  }
}
```

## Variables

- `function_name` - Name of the Lambda function
- `zip_file_path` - Path to the function zip file
- `handler` - Handler function (default: handler.lambda_handler)
- `runtime` - Runtime environment (default: python3.11)
- `timeout` - Timeout in seconds (default: 30)
- `memory_size` - Memory in MB (default: 128)
- `environment_variables` - Environment variables for the function
- `log_retention_days` - CloudWatch log retention (default: 14)
- `common_tags` - Tags to apply to all resources

## Outputs

- `lambda_function_arn` - ARN of the Lambda function
- `lambda_function_name` - Name of the Lambda function
- `lambda_function_invoke_arn` - Invoke ARN
- `lambda_role_arn` - ARN of the execution role
- `log_group_name` - CloudWatch log group name
- `log_group_arn` - CloudWatch log group ARN
