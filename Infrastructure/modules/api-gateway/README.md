# API Gateway Module

Creates an HTTP API Gateway integrated with Lambda function.

## Features

- **HTTP API Gateway**: Modern, cost-effective API endpoint
- **Lambda Integration**: AWS_PROXY integration for serverless APIs
- **CORS Support**: Configurable cross-origin resource sharing
- **Access Logs**: CloudWatch logs for all API requests
- **Auto Deploy**: Automatic deployment on configuration changes
- **IAM Integration**: Lambda permissions for API Gateway invocation

## Resources Created

- 1x API Gateway (HTTP)
- 1x API Stage (deployment)
- 1x Lambda Integration
- 1x Route ($default for all paths)
- 1x Lambda Permission (for API Gateway invocation)
- 1x CloudWatch Log Group (for access logs)

## Usage

```hcl
module "api_gateway" {
  source = "../modules/api-gateway"

  api_name               = "employee-api"
  environment            = "dev"
  lambda_function_name   = "private-api-rest-api-dev"
  lambda_invoke_arn      = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:..."
  authorization_type    = "NONE"
  cors_allow_origins    = ["*"]
  cors_allow_methods    = ["GET", "POST", "PUT", "DELETE"]
  log_retention_days    = 7
  common_tags           = var.common_tags
}
```

## Outputs

- `api_id`: API Gateway ID
- `api_endpoint`: Public API endpoint URL
- `api_arn`: API Gateway ARN
- `api_execution_arn`: API Gateway execution ARN
- `stage_name`: Stage name (environment)
- `log_group_name`: CloudWatch log group name
- `log_group_arn`: CloudWatch log group ARN

## API Endpoint

The API endpoint will be in the format:
```
https://<api-id>.execute-api.<region>.amazonaws.com/<stage>/
```

Example:
```
https://abc123def.execute-api.us-east-1.amazonaws.com/dev/
```

## CORS Configuration

Configure CORS for client-side API access:
- `cors_allow_origins`: List of allowed origins (default: ["*"])
- `cors_allow_methods`: List of allowed HTTP methods
- `cors_allow_headers`: List of allowed headers

## Authorization

Set authorization type:
- `NONE`: Public API (default)
- `AWS_IAM`: AWS IAM authentication
- `CUSTOM`: Custom Lambda authorizer

## Logging

Access logs are sent to CloudWatch:
- Log Group: `/aws/apigateway/<api-name>-<environment>`
- Retention: Configurable (default: 7 days)
- Format: JSON with request/response details

## Integration with Lambda

The module automatically:
1. Creates AWS_PROXY integration with Lambda
2. Creates $default route pointing to Lambda
3. Adds Lambda permission for API Gateway invocation
4. Configures auto-deploy for seamless updates

## Cost Considerations

HTTP API Gateway pricing:
- ~$0.30 per million API requests
- Much cheaper than REST API ($3.50 per million)
- No data transfer charges within AWS
- Minimal CloudWatch logging costs

## Examples

### Get Employee Details
```bash
curl https://api-id.execute-api.region.amazonaws.com/dev/ \
  -H "Content-Type: application/json" \
  -d '{"employeeId": "EMP001"}'
```

### Check API Status
```bash
curl https://api-id.execute-api.region.amazonaws.com/dev/
```
