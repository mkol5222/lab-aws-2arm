
module "gateway_load_balancer" {

  source = "../../modules/load_balancer"

  load_balancers_type = "gateway"
  instances_subnets   = var.private_subnets
  prefix_name         = var.gateway_load_balancer_name
  internal            = true

  security_groups = []
  tags = {
    x-chkp-management = var.management_server
    x-chkp-template   = var.configuration_template
  }
  vpc_id                    = var.vpc_id
  load_balancer_protocol    = "GENEVE"
  target_group_port         = 6081
  listener_port             = 6081
  cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  ip_mode                   = var.ip_mode


  // default tcp timeout 1 hour
  tcp_idle_timeout = 3600
}

resource "aws_vpc_endpoint_service" "gwlb_endpoint_service" {
  depends_on = [module.gateway_load_balancer]

  acceptance_required        = false
  gateway_load_balancer_arns = module.gateway_load_balancer[*].load_balancer_arn
  supported_ip_address_types = var.ip_mode != "IPv4" ? ["ipv4", "ipv6"] : ["ipv4"]

  tags = {
    Name = "gwlb-endpoint-service-${var.gateway_load_balancer_name}"
  }
}