output "management_public_ip" {
  description = "Management server public IP address"
  value       = module.management.management_public_ip
}

output "management_url" {
  description = "Management server SmartConsole URL"
  value       = module.management.management_url
}

output "management_instance_id" {
  description = "Management server EC2 instance ID"
  value       = module.management.management_instance_id
}

output "gateway_asg_name" {
  description = "Gateway Auto Scaling Group name"
  value       = module.fw.gateway_asg_name
}

output "gateway_instance_private_ips" {
  description = "Private IP addresses of current gateway ASG instances"
  value       = module.fw.gateway_instance_private_ips
}

output "gateway_instance_ids" {
  description = "Instance IDs of current gateway ASG instances"
  value       = module.fw.gateway_instance_ids
}

output "gateway_instance_public_ips" {
  description = "Public IP addresses of current gateway ASG instances"
  value       = module.fw.gateway_instance_public_ips
}
