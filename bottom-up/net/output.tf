
output "vpcid" {
  value = module.launch_vpc.vpc_id
}

output "public_subnets" {
  value = module.launch_vpc.public_subnets_ids_list
}
output "private_subnets" {
  value = module.launch_vpc.private_subnets_ids_list
}

output "internet_gateway_id" {
  value = module.launch_vpc.aws_igw
}