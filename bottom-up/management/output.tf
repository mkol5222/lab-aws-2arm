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
