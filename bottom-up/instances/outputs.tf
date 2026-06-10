output "ubuntu_instance_id" {
  description = "Ubuntu egress test instance ID."
  value       = aws_instance.ubuntu.id
}

output "ubuntu_public_ip" {
  description = "Ubuntu egress test instance public IP."
  value       = aws_instance.ubuntu.public_ip
}

output "vm_subnet_ids" {
  description = "VM subnet IDs by Availability Zone."
  value       = { for az, subnet in aws_subnet.vm_subnets : az => subnet.id }
}

output "gwlbe_ids" {
  description = "Gateway Load Balancer endpoint IDs by Availability Zone."
  value       = { for az, endpoint in aws_vpc_endpoint.gwlbe : az => endpoint.id }
}