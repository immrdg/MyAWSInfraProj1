# Infrastructure as Code with Terragrunt

This directory contains the infrastructure setup using Terraform and Terragrunt for managing AWS resources across multiple environments.

## Directory Structure

```
Infrastructure/
├── modules/
│   ├── s3/                    # S3 bucket module (reusable)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── common/                # Common variables (shared across modules)
│       └── variables.tf
├── app/                       # Main application module
│   ├── main.tf               # Uses s3 module
│   ├── variables.tf
│   └── outputs.tf
├── env/
│   ├── dev/                  # Development environment
│   │   └── terragrunt.hcl
│   └── prod/                 # Production environment
│       └── terragrunt.hcl
├── terragrunt.hcl            # Root configuration
└── README.md
```

## How It Works

### Module Architecture
- **modules/s3/**: Reusable S3 bucket module with versioning, encryption, and public access blocking
- **modules/common/**: Shared variables and tags
- **app/**: Main application module that orchestrates and uses the s3 module
- **env/**: Environment-specific configurations that call the app module

### Terragrunt Flow
1. Environment configs (dev/terragrunt.hcl, prod/terragrunt.hcl) inherit from root config
2. Each environment calls the `app` module with environment-specific inputs
3. The `app` module uses the `s3` module to create resources
4. Remote state is configured to store tfstate in S3 with DynamoDB locking

## Usage

### Deploy to Development
```bash
cd env/dev
terragrunt plan
terragrunt apply
```

### Deploy to Production
```bash
cd env/prod
terragrunt plan
terragrunt apply
```

### Run All Environments
```bash
terragrunt run-all plan
terragrunt run-all apply
```

### Destroy Resources
```bash
# Dev
cd env/dev
terragrunt destroy

# Or all environments
terragrunt run-all destroy
```

## Configuration Details

### Development Environment (`env/dev/terragrunt.hcl`)
- Versioning: **Disabled** (cost optimization)
- Region: us-east-1
- Tags: Environment = "dev"

### Production Environment (`env/prod/terragrunt.hcl`)
- Versioning: **Enabled** (data protection)
- Region: us-east-1
- Tags: Environment = "prod"

## Resource Naming Convention
S3 buckets are named as: `{project_name}-bucket-{environment}`

Example:
- Dev: `myproject-bucket-dev`
- Prod: `myproject-bucket-prod`

## Security Features

The S3 module includes:
- ✅ Server-side encryption (AES256)
- ✅ Versioning (configurable)
- ✅ Public access blocking
- ✅ Environment-specific tags
- ✅ Automated naming

## Remote State

Remote state is configured in the root `terragrunt.hcl`:
- Backend: S3
- State Lock: DynamoDB
- Encryption: Enabled
- Per-environment isolation: `env/dev/terraform.tfstate`, `env/prod/terraform.tfstate`

## Adding New Modules

1. Create a new module in `modules/{name}/` with main.tf, variables.tf, outputs.tf
2. Import it in `app/main.tf` using `module` block
3. Pass required variables from `app/variables.tf`
4. Run `terragrunt plan` to validate

## Prerequisites

- Terraform >= 1.0
- Terragrunt >= 0.40.0
- AWS credentials configured
- S3 bucket for remote state (create manually first or update backend config)
