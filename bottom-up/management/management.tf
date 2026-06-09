data "aws_region" "current" {}


# Route table for Management Subnet
# Routes management traffic directly to Internet Gateway for external access
resource "aws_route_table" "management_subnet_rtb" {
  vpc_id = var.vpc_id
  tags = {
    Name    = "Management Subnet Route Table"
    Network = "Public"
  }
}

# Default route to Internet Gateway for management subnet
resource "aws_route" "management_igw_route" {
  route_table_id         = aws_route_table.management_subnet_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# IPv6 default route to Internet Gateway for management subnet
resource "aws_route" "management_igw_route_ipv6" {
  count                       = var.ipv6_enabled ? 1 : 0
  route_table_id              = aws_route_table.management_subnet_rtb.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = var.internet_gateway_id
}

# Associates management subnet with its route table
resource "aws_route_table_association" "management_subnet_rtb_assoc" {
  subnet_id      = aws_subnet.management_subnet.id
  route_table_id = aws_route_table.management_subnet_rtb.id
}

resource "aws_subnet" "management_subnet" {
  vpc_id                                         = var.vpc_id
  availability_zone                              = element(var.availability_zones, 0)
  cidr_block                                     = var.management_subnet_cidr
  ipv6_cidr_block                                = null
  ipv6_native                                    = false
  assign_ipv6_address_on_creation                = false
  enable_resource_name_dns_a_record_on_launch    = true
  enable_resource_name_dns_aaaa_record_on_launch = false
  map_public_ip_on_launch                        = true
  tags = {
    Name    = var.deployment_prefix != "" ? "${var.deployment_prefix}-Management subnet" : "Management subnet"
    Network = "Public"
  }
}


module "management" {
  
  source = "../../modules/management"

  vpc_id                     = var.vpc_id
  subnet_id                  = aws_subnet.management_subnet.id
  management_name            = var.management_server
  management_instance_type   = "m5.xlarge"
  key_name                   = var.sshkey_name
  ip_mode                    = "IPv4"
  allocate_and_associate_eip = true

  volume_size                  = 200
  enable_instance_connect      = true
  disable_instance_termination = false
  allow_upload_download        = true
  admin_shell                  = "/bin/bash"
  volume_encryption            = ""

  metadata_imdsv2_required = true
  management_version       = "R82-BYOL"
  # AdminIzK1ng
  management_password_hash                  = "$6$DHQpTr08lvGpgnVW$vzx/uMa9/gyR.ZOKGHa6pe8l6Cim.UX9q6Nv.7VCUJTR9TF9OZUsPkd2Yvt21O9epyhVj/Ig9bnqma8uawrD70"
  management_maintenance_mode_password_hash = ""

  admin_cidr = "0.0.0.0/0"


  gateway_addresses           = "0.0.0.0/0"
  gateway_management          = "Locally managed"
  management_bootstrap_script = "autoprov_cfg -f init AWS -mn ${var.management_server} -tn ${var.configuration_template} -cn gwlb-controller -po Standard -otp ${var.gateway_SICKey} -r ${data.aws_region.current.name} -ver R82 -iam; echo -e '\nFinished Bootstrap script\n'"
  // volume_type = var.volume_type
  is_gwlb = true
  // security_rules = var.management_security_rules
}
