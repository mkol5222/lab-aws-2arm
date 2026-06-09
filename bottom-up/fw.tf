module "fw" {
  source = "./fw"

  depends_on = [module.net]

  deployment_prefix          = local.deployment_prefix
  vpc_id                     = module.net.vpcid
  private_subnets            = module.net.private_subnets
  public_subnets             = module.net.public_subnets
  sshkey_name                = var.sshkey_name
  gateway_SICKey             = local.gateway_SICKey
  gateway_load_balancer_name = local.gateway_load_balancer_name
  management_server          = local.management_server
  configuration_template     = local.configuration_template

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  ip_mode                          = var.ip_mode
}