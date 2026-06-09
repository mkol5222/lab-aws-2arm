// autoscale_gwlb_dual_arm

module "cpfw" {

  source = "../../modules/autoscale_gwlb_dual_arm"

  // --- Environment ---
  deployment_prefix = var.deployment_prefix

  // --- VPC Network Configuration ---
  vpc_id                   = var.vpc_id
  gateways_private_subnets = var.private_subnets
  gateways_public_subnets  = var.public_subnets

  // --- Automatic Provisioning with Security Management Server Settings ---
  gateways_provision_address_type = "private"

  // tags
  management_server      = var.management_server
  configuration_template = var.configuration_template

  // --- EC2 Instances Configuration ---
  gateway_instance_type = "c6in.xlarge"
  key_name              = var.sshkey_name
  ip_mode               = var.ip_mode
  instances_tags = {
    key1 = "value1"
    key2 = "value2"
  }

  // --- Auto Scaling Configuration ---
  minimum_group_size = 1
  maximum_group_size = 2
  // target_groups = ["arn:aws:tg1/abc123", "arn:aws:tg2/def456"]
  target_groups = module.gateway_load_balancer[*].target_group_arn

  // --- Check Point Settings ---
  gateway_version                        = "R82-BYOL"
  admin_shell                            = "/bin/bash"
  gateway_password_hash                  = ""
  gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
  gateway_SICKey                         = var.gateway_SICKey
  enable_instance_connect                = true
  allow_upload_download                  = true
  enable_cloudwatch                      = false
  gateway_bootstrap_script               = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
}