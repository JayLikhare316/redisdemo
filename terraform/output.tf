output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "public_security_group_id" {
  value = module.network.public_security_group_id
}

output "private_security_group_id" {
  value = module.network.private_security_group_id
}

output "public_instance_ips" {
  value = module.instance.public_instance_ips
}

output "private_instance_ips" {
  value = module.instance.private_instance_ips
}
