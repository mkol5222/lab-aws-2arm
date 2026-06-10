module "instances" {
  source = "./instances"

  depends_on = [module.net, module.fw]

  deployment_prefix   = local.deployment_prefix
  vpc_id              = module.net.vpcid
  vpc_cidr            = "10.0.0.0/16"
  internet_gateway_id = module.net.internet_gateway_id
  availability_zones  = var.availability_zones
  gwlb_service_name   = module.fw.gwlb_service_name
  sshkey_name         = var.sshkey_name

}