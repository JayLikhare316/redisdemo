output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.redis-VPC.id
}

output "public_subnet_ids" {
  description = "A list of IDs for the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "A list of IDs for the private subnets."
  value       = aws_subnet.private[*].id
}

output "public_security_group_id" {
  description = "The ID of the public security group."
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "The ID of the private security group."
  value       = aws_security_group.private.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.redis-VPC.cidr_block
}
