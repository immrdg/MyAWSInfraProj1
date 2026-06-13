# VPC Module

Creates a VPC with public and private subnets across multiple availability zones.

## Features

- **VPC**: Configurable CIDR block
- **Public Subnets**: For resources that need internet access (load balancers, bastion hosts)
- **Private Subnets**: For resources that should not be directly internet-accessible
- **Internet Gateway**: For public subnet internet access

## Resources Created

- 1x VPC
- N x Public Subnets (one per availability zone)
- N x Private Subnets (one per availability zone)
- 1x Internet Gateway
- 1x Public Route Table
- N x Private Route Tables (one per AZ)

## Network Design

### Dev Environment
```
VPC: 10.0.0.0/16
├── Public Subnets:  10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24
└── Private Subnets: 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24
```

### Prod Environment
```
VPC: 10.1.0.0/16
├── Public Subnets:  10.1.1.0/24, 10.1.2.0/24, 10.1.3.0/24
└── Private Subnets: 10.1.11.0/24, 10.1.12.0/24, 10.1.13.0/24
```

## Usage

```hcl
module "vpc" {
  source = "../modules/vpc"

  environment            = "dev"
  vpc_cidr               = "10.0.0.0/16"
  public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs   = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  common_tags            = var.common_tags
}
```

## Outputs

- `vpc_id`: VPC identifier
- `vpc_cidr`: VPC CIDR block
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs
- `internet_gateway_id`: Internet Gateway ID

## High Availability

- Multiple availability zones (one subnet per AZ)
- Separate route tables per AZ for optimal routing
- Distributed across 3 AZs for fault tolerance

## Security

- Private subnets are isolated (no direct internet access)
- Public subnets are exposed to the internet via IGW
- Network ACLs and security groups provide additional protection
