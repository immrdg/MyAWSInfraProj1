# Private API Gateway - API Documentation

## Overview

The Private API Gateway provides a RESTful HTTP API for retrieving employee information. It's built using AWS API Gateway (HTTP), Lambda, and deployed via Terraform infrastructure-as-code.

**API Endpoint (Dev):** `https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/`

## Features

✅ Public API (no authentication required)  
✅ Multiple input formats supported (query params, JSON body, path params)  
✅ Comprehensive error handling (400, 404, 500)  
✅ Structured JSON responses  
✅ CloudWatch logging for all requests  
✅ CORS enabled for cross-origin requests  

## Request Methods

The API uses HTTP GET and POST methods through a catch-all route (`$default`).

### Method: GET with Query String

Get employee details using query parameters.

```bash
GET /dev/?employeeId=EMP001
```

**Example:**
```bash
curl -X GET "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001"
```

**Response (200 OK):**
```json
{
  "id": "EMP001",
  "name": "John Doe",
  "email": "john.doe@company.com",
  "department": "Engineering",
  "position": "Senior Developer",
  "salary": 120000
}
```

### Method: POST with JSON Body

Get employee details using JSON request body.

```bash
POST /dev/
Content-Type: application/json

{"employeeId": "EMP002"}
```

**Example:**
```bash
curl -X POST "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/" \
  -H "Content-Type: application/json" \
  -d '{"employeeId": "EMP002"}'
```

**Response (200 OK):**
```json
{
  "id": "EMP002",
  "name": "Jane Smith",
  "email": "jane.smith@company.com",
  "department": "Product",
  "position": "Product Manager",
  "salary": 110000
}
```

## Response Formats

### Success Response (200 OK)

Returns employee details as JSON object:

```json
{
  "id": "string",
  "name": "string",
  "email": "string",
  "department": "string",
  "position": "string",
  "salary": number
}
```

### Error: Missing Employee ID (400 Bad Request)

```bash
GET /dev/
```

**Response:**
```json
{
  "error": "employeeId is required"
}
```

### Error: Employee Not Found (404 Not Found)

```bash
GET /dev/?employeeId=EMP999
```

**Response:**
```json
{
  "error": "Employee EMP999 not found"
}
```

### Error: Server Error (500 Internal Server Error)

```json
{
  "error": "error message"
}
```

## Available Employees

The API has three mock employees available:

| ID | Name | Department | Position | Salary |
|----|------|------------|----------|--------|
| EMP001 | John Doe | Engineering | Senior Developer | 120000 |
| EMP002 | Jane Smith | Product | Product Manager | 110000 |
| EMP003 | Bob Johnson | Sales | Sales Executive | 95000 |

## Input Parameter Priority

The Lambda handler checks for `employeeId` in the following order:

1. **Direct event object**: `{"employeeId": "EMP001"}`
2. **JSON body** (for POST): `{"body": "{\"employeeId\": \"EMP001\"}"}`
3. **Query parameters** (for GET): `?employeeId=EMP001`
4. **Path parameters**: `pathParameters.employeeId`

## CORS Configuration

The API allows cross-origin requests from all origins (`*`).

**CORS Headers Enabled:**
- `Access-Control-Allow-Origin: *`
- `Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS`
- `Access-Control-Allow-Headers: Content-Type, Authorization, X-Amz-Date`

**Preflight Request:**
```bash
OPTIONS /dev/
```

## CloudWatch Logging

All API requests are logged to CloudWatch with the following format:

```json
{
  "requestId": "string",
  "ip": "string",
  "requestTime": "string",
  "httpMethod": "string",
  "routeKey": "string",
  "status": number,
  "protocol": "string",
  "responseLength": number,
  "integrationLatency": number,
  "error": "string",
  "errorType": "string"
}
```

**Log Group:** `/aws/apigateway/private-api-api-dev`

## API Gateway Details

- **API Type**: HTTP API (APIGatewayV2)
- **API ID**: `aqfmsxffbg`
- **Stage**: `dev`
- **Protocol**: HTTP/1.1
- **Route Key**: `$default` (catch-all)
- **Integration**: AWS_PROXY with Lambda
- **Lambda Function**: `private-api-rest-api-dev`
- **Region**: `us-east-1`

## Performance Characteristics

- **Integration Latency**: ~50-100ms typical
- **Cold Start**: ~500ms for first invocation
- **Memory**: 128MB (dev), 256MB (prod)
- **Timeout**: 30s (dev), 60s (prod)
- **Concurrency**: AWS account limits apply

## Testing the API

### Using curl

**Get single employee:**
```bash
curl -s "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001" | jq
```

**Get employee via POST:**
```bash
curl -s -X POST "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/" \
  -H "Content-Type: application/json" \
  -d '{"employeeId": "EMP002"}' | jq
```

**Error handling:**
```bash
# Missing parameter
curl -s "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/" | jq

# Non-existent employee
curl -s "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP999" | jq
```

### Using Python

```python
import requests
import json

# Get employee details
response = requests.get(
    "https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/",
    params={"employeeId": "EMP001"}
)

employee = response.json()
print(json.dumps(employee, indent=2))
```

### Using JavaScript/Node.js

```javascript
// Fetch employee details
const response = await fetch(
  'https://aqfmsxffbg.execute-api.us-east-1.amazonaws.com/dev/?employeeId=EMP001'
);
const employee = await response.json();
console.log(JSON.stringify(employee, null, 2));
```

## Monitoring & Debugging

### View API Logs

```bash
aws logs tail /aws/apigateway/private-api-api-dev --follow
```

### View Lambda Logs

```bash
aws logs tail /aws/lambda/private-api-rest-api-dev --follow
```

### Check API Gateway Status

```bash
aws apigatewayv2 get-api --api-id aqfmsxffbg --region us-east-1
```

## Deployment Information

- **Infrastructure as Code**: Terraform
- **Configuration Management**: Terragrunt
- **Repository Branch**: `infra/api-gateway`
- **Last Updated**: 2026-06-13
- **Status**: Production Ready ✓

## Troubleshooting

### "No Route Matched"
- Ensure you're using the correct API endpoint
- The route is `$default` (catch-all), should match any path

### "Lambda Unresponsive"
- Check Lambda function status in AWS Console
- View CloudWatch logs for Lambda errors
- Verify Lambda execution role has proper permissions

### "CORS Error in Browser"
- API has CORS enabled for all origins
- Check browser console for actual error message
- Verify request headers are correct

### "502 Bad Gateway"
- API Gateway cannot reach Lambda
- Check Lambda permissions (`aws_lambda_permission`)
- Check CloudWatch logs for Lambda errors

## Infrastructure Stack

```
Internet → API Gateway (HTTP)
           ↓
        Lambda Function
        ↓
     Mock Database
     (in-memory)
```

### AWS Resources

**API Gateway Layer:**
- 1× HTTP API Gateway
- 1× Stage (dev/prod)
- 1× Integration (AWS_PROXY to Lambda)
- 1× Route ($default)
- 1× Lambda Permission
- 1× CloudWatch Log Group

**Lambda Layer:**
- 1× Lambda Function
- 1× IAM Execution Role
- 1× CloudWatch Log Group

**Networking:**
- 1× VPC (10.0.0.0/16 dev, 10.1.0.0/16 prod)
- 3× Public Subnets
- 3× Private Subnets
- 1× Internet Gateway

## Support & Maintenance

For issues or feature requests:
1. Check CloudWatch logs
2. Review Terraform state
3. Verify AWS resource permissions
4. Check Lambda function code

## Next Steps

- [ ] Add authentication (AWS IAM, Custom Authorizer)
- [ ] Implement request validation
- [ ] Add API key management
- [ ] Set up custom domain
- [ ] Create OpenAPI/Swagger specification
- [ ] Add rate limiting
- [ ] Implement caching

---

**API Version**: 1.0  
**Last Updated**: 2026-06-13  
**Status**: ✅ Live & Tested
