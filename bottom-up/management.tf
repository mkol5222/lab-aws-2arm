module "management" {
  source = "./management"

  depends_on = [module.net]

  vpc_id                 = module.net.vpcid
  internet_gateway_id    = module.net.internet_gateway_id
  ipv6_enabled           = local.ipv6_enabled
  availability_zones     = var.availability_zones
  management_subnet_cidr = var.management_subnet_cidr
  deployment_prefix      = local.deployment_prefix
  management_server      = local.management_server
  sshkey_name            = var.sshkey_name
  configuration_template = local.configuration_template
  gateway_SICKey         = local.gateway_SICKey
}