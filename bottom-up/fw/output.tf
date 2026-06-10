data "aws_instances" "gateway_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [module.cpfw.autoscale_autoscaling_group_name]
  }
  filter {
    name   = "instance-state-name"
    values = ["running", "pending"]
  }
}

output "gateway_asg_name" {
  description = "Gateway Auto Scaling Group name"
  value       = module.cpfw.autoscale_autoscaling_group_name
}

output "gateway_instance_private_ips" {
  description = "Private IP addresses of current gateway ASG instances"
  value       = data.aws_instances.gateway_instances.private_ips
}

output "gateway_instance_ids" {
  description = "Instance IDs of current gateway ASG instances"
  value       = data.aws_instances.gateway_instances.ids
}

data "aws_network_interfaces" "gateway_enis" {
  filter {
    name   = "attachment.instance-id"
    values = data.aws_instances.gateway_instances.ids
  }
}

data "aws_eips" "gateway_eips" {
  filter {
    name   = "network-interface-id"
    values = tolist(data.aws_network_interfaces.gateway_enis.ids)
  }
}

output "gateway_instance_public_ips" {
  description = "Public IP addresses (EIPs) associated with gateway ASG instance ENIs"
  value       = data.aws_eips.gateway_eips.public_ips
}

output "gwlb_service_name" {
  description = "Gateway Load Balancer endpoint service name"
  value       = aws_vpc_endpoint_service.gwlb_endpoint_service.service_name
}
