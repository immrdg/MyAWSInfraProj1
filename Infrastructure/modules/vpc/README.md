# VPC Module

Creates a VPC with public and private subnets across multiple availability zones.

## Features

- **VPC**: Configurable CIDR block
- **Public Subnets**: For resources that need internet access (load balancers, NAT gateways)
- **Private Subnets**: For resources that should not be directly internet-accessible (Lambda, databases)
- **Internet Gateway**: For public subnet internet access
- **NAT Gateways**: For private subnet egress (one per AZ for high availability)
- **Route Tables**: Separate route tables for public and private subnets

## Resources Created

- 1x VPC
- N x Public Subnets (one per availability zone)
- N x Private Subnets (one per availability zone)
- 1x Internet Gateway
- N x NAT Gateways (one per AZ)
- N x Elastic IPs (for NAT Gateways)
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
- `nat_gateway_ids`: List of NAT Gateway IDs
- `internet_gateway_id`: Internet Gateway ID

## High Availability

- Multiple availability zones (one subnet per AZ)
- One NAT Gateway per AZ for private subnet egress
- Separate route tables per AZ for optimal routing

## Security

- Private subnets cannot directly reach the internet
- NAT Gateways provide controlled egress from private subnets
- Public subnets are exposed to the internet via IGW
