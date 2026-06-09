
module "gateway_load_balancer" {
  source = "../modules/load_balancer"

  load_balancers_type = "gateway"
  instances_subnets =  module.net.private_subnets
  prefix_name = local.gateway_load_balancer_name
  internal = true

  security_groups = []
  tags = {
    x-chkp-management = local.management_server
    x-chkp-template = local.configuration_template
  }
  vpc_id = module.net.vpc_id
  load_balancer_protocol = "GENEVE"
  target_group_port = 6081
  listener_port = 6081
  cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  ip_mode = var.ip_mode

  // default tcp timeout 1 hour
  tcp_idle_timeout = 3600
}