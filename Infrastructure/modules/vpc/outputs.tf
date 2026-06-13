output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "Public subnet details"
  value = {
    for subnet in aws_subnet.public :
    subnet.id => {
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  }
}

output "private_subnets" {
  description = "Private subnet details"
  value = {
    for subnet in aws_subnet.private :
    subnet.id => {
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  }
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}
