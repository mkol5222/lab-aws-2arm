

module "net" {
  source = "./net"


  // --- VPC Network Configuration ---
  vpc_cidr = "10.0.0.0/16"
  public_subnets_map = {
    "eu-central-1a" = 1
    "eu-central-1b" = 2
    "eu-central-1c" = 3

  }
  private_subnets_map = {
    "eu-central-1a" = 9
    "eu-central-1b" = 10
    "eu-central-1c" = 11

  }
  tgw_subnets_map = {
    "eu-central-1a" = 5
    "eu-central-1b" = 6
    "eu-central-1c" = 7

  }
  subnets_bit_length = 8

  availability_zones = var.availability_zones
  number_of_AZs      = 3
}