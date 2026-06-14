# Private API Gateway - Lambda REST API Deployment Ready

## Project Status: ✅ READY FOR DEPLOYMENT

### Overview
This project implements a REST API Lambda function that returns employee details based on employee ID, backed by Terraform infrastructure-as-code.

---

## Architecture Components

### 1. Lambda Function (Python)
- **Location**: `lambda/rest-api/`
- **Handler**: `handler.lambda_handler`
- **Runtime**: Python 3.11
- **Purpose**: REST API endpoint that accepts `employeeId` and returns employee details

**Features**:
- Mock employee database (3 sample employees)
- Proper HTTP response format with status codes (200, 400, 404, 500)
- Support for multiple input formats (direct event and pathParameters)
- Comprehensive error handling

**Testing**:
- ✅ 8 unit tests passing
- ✅ 100% code coverage
- ✅ Test coverage: `htmlcov/` directory

**Code Quality**:
- ✅ Linting with flake8 and mypy
- ✅ Code formatting with black (line-length: 100)
- ✅ All standards met

### 2. Infrastructure (Terraform)

#### Modules Created:
1. **Lambda Module** (`Infrastructure/modules/lambda/`)
   - AWS Lambda function
   - IAM role with basic execution permissions
   - CloudWatch log group

2. **Project Module** (`Infrastructure/modules/project/`)
   - Orchestrates Lambda and S3 modules
   - Creates complete project stack
   - Used by app layer

3. **S3 Module** (existing)
   - S3 bucket for Lambda artifacts
   - Versioning enabled
   - Encryption enabled
   - Public access blocked

#### App Layer (`Infrastructure/app/`)
- References project module
- Configurable for different environments
- Exposes all outputs (Lambda ARN, S3 bucket, CloudWatch logs)

#### Environment Configurations:
- **Dev** (`Infrastructure/env/dev/terragrunt.hcl`):
  - Lambda: 128 MB memory, 30s timeout
  - Logs: 7-day retention
  
- **Prod** (`Infrastructure/env/prod/terragrunt.hcl`):
  - Lambda: 256 MB memory, 60s timeout
  - Logs: 30-day retention

---

## Deployment Package

**File**: `lambda/rest-api/lambda-function.zip` (13 MB)
- **Built with**: `make build`
- **Contents**:
  - handler.py (Lambda function code)
  - All production dependencies (boto3, requests, etc.)
- **Status**: ✅ Ready for deployment

---

## Deployment Steps

### Prerequisites
- AWS credentials configured (profile: `immrdg21`)
- AWS region: `us-east-1`
- Terraform/Terragrunt installed

### Step 1: Verify Terraform Plan (Dev Environment)
```bash
cd Infrastructure/env/dev
terragrunt plan
```
**Expected Output**: 8 resources to add (Lambda, IAM, CloudWatch, S3, etc.)

### Step 2: Deploy Infrastructure (Dev Environment)
```bash
cd Infrastructure/env/dev
terragrunt apply
```
**Confirms**: Creates all resources in AWS

### Step 3: Verify Lambda Function
```bash
aws lambda invoke \
  --function-name private-api-rest-api-dev \
  --payload '{"employeeId": "EMP001"}' \
  response.json \
  --region us-east-1 \
  --profile immrdg21

cat response.json
```

### Step 4: Deploy to Production (if needed)
```bash
cd Infrastructure/env/prod
terragrunt plan
terragrunt apply
```

---

## Project Structure
```
.
├── lambda/rest-api/                  # Lambda function (Python)
│   ├── handler.py                    # Lambda handler
│   ├── test_handler.py               # Tests (100% coverage)
│   ├── lambda-function.zip           # Deployment package
│   ├── Makefile                      # Build/test automation
│   ├── pyproject.toml                # Python project config
│   ├── requirements.txt              # Production dependencies
│   └── .python-version               # Python 3.11
│
├── Infrastructure/                   # Terraform Infrastructure
│   ├── app/                          # App layer (uses project module)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── modules/
│   │   ├── lambda/                   # Lambda module
│   │   ├── project/                  # Project orchestration module
│   │   ├── s3/                       # S3 module
│   │   └── common/                   # Common variables
│   │
│   └── env/
│       ├── dev/                      # Dev environment
│       ├── prod/                     # Prod environment
│       └── terragrunt.hcl            # Root terragrunt config
│
└── DEPLOYMENT_READY.md               # This file
```

---

## Git Branches
- **main**: Latest stable code
- **infra/lambda**: Lambda function implementation (merged to main)
- **infra/lambda-terraform**: Terraform infrastructure (current branch)

---

## Testing Locally

### Run All Tests
```bash
cd lambda/rest-api
make test
```

### Run Linting
```bash
cd lambda/rest-api
make lint
```

### Format Code
```bash
cd lambda/rest-api
make format
```

### Clean Up
```bash
cd lambda/rest-api
make clean        # Remove build artifacts
make clean-venv   # Remove virtual environment
```

---

## Environment Variables

### Lambda Environment Variables
**Dev**: `ENVIRONMENT=dev`
**Prod**: `ENVIRONMENT=prod`

Can be extended by updating `lambda_environment_variables` in:
- `Infrastructure/env/dev/terragrunt.hcl`
- `Infrastructure/env/prod/terragrunt.hcl`

---

## Outputs After Deployment

After running `terragrunt apply`, you'll have:
- **Lambda Function ARN**: `arn:aws:lambda:us-east-1:...:function:private-api-rest-api-dev`
- **Lambda Function Name**: `private-api-rest-api-dev`
- **IAM Role ARN**: `arn:aws:iam::...:role/private-api-rest-api-dev-role`
- **CloudWatch Log Group**: `/aws/lambda/private-api-rest-api-dev`
- **S3 Bucket**: `private-api-lambda-artifacts-dev`

---

## Next Steps

1. **Deploy Infrastructure**:
   ```bash
   cd Infrastructure/env/dev && terragrunt apply
   ```

2. **Test Lambda Function** (after deployment):
   ```bash
   aws lambda invoke --function-name private-api-rest-api-dev \
     --payload '{"employeeId": "EMP001"}' response.json \
     --region us-east-1 --profile immrdg21
   ```

3. **Create API Gateway** (optional):
   - Set up HTTP/REST API Gateway to invoke the Lambda function
   - Configure authentication/authorization as needed

4. **Monitor**:
   - CloudWatch Logs: `/aws/lambda/private-api-rest-api-dev`
   - CloudWatch Metrics for Lambda performance

---

## Troubleshooting

### Issue: Terraform can't find zip file
**Solution**: Ensure `make build` was run in `lambda/rest-api/`

### Issue: Lambda execution fails
**Solution**: Check CloudWatch logs at `/aws/lambda/private-api-rest-api-dev`

### Issue: IAM permission denied
**Solution**: Verify AWS credentials are correct:
```bash
aws sts get-caller-identity --profile immrdg21
```

---

## Support
For issues or questions, check:
- Lambda handler code: `lambda/rest-api/handler.py`
- Lambda tests: `lambda/rest-api/test_handler.py`
- Infrastructure modules: `Infrastructure/modules/`
