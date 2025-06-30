output "public_instance_ids" {
  description = "A list of IDs for the public instances."
  value       = aws_instance.public[*].id
}

output "private_instance_ids" {
  description = "A list of IDs for the private instances."
  value       = aws_instance.private[*].id
}

output "public_instance_ips" {
  description = "A list of public IP addresses for the public instances."
  value       = aws_instance.public[*].public_ip
}

output "private_instance_ips" {
  description = "A list of private IP addresses for the private instances."
  value       = aws_instance.private[*].private_ip
}
