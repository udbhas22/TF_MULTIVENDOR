
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "The ID of the shared security group"
  value       = module.security_group.security_group_id
}

output "subnet_ids" {
  value = { for k, subnet in module.subnet : k => subnet.subnet_id }
}