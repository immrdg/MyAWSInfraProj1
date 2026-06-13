resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-vpc"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-igw"
    }
  )
}

# Public subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-public-subnet-${count.index + 1}"
      Type = "Public"
    }
  )
}

# Private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-private-subnet-${count.index + 1}"
      Type = "Private"
    }
  )
}

# Elastic IPs for NAT Gateways
# resource "aws_eip" "nat" {
#   count  = length(var.private_subnet_cidrs)
#   domain = "vpc"

#   tags = merge(
#     var.common_tags,
#     {
#       Name = "${var.environment}-eip-${count.index + 1}"
#     }
#   )

#   depends_on = [aws_internet_gateway.main]
# }

# NAT Gateways for private subnets
# resource "aws_nat_gateway" "main" {
#   count         = length(var.private_subnet_cidrs)
#   allocation_id = aws_eip.nat[count.index].id
#   subnet_id     = aws_subnet.public[count.index].id

#   tags = merge(
#     var.common_tags,
#     {
#       Name = "${var.environment}-nat-${count.index + 1}"
#     }
#   )

#   depends_on = [aws_internet_gateway.main]
# }

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-public-rt"
    }
  )
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route tables (one per AZ for NAT Gateway resilience)
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.main[count.index].id
  # }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-private-rt-${count.index + 1}"
    }
  )
}

# Associate private subnets with their respective route tables
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Data source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}
