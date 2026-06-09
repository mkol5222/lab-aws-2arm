output "debug" {
  value = {
    vpc_id          = module.net.vpcid
    public_subnets  = module.net.public_subnets
    private_subnets = module.net.private_subnets
  }
}