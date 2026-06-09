// autoscale_gwlb_dual_arm

provider "aws" {}

module "cpfw" {

    source  = "../modules/autoscale_gwlb_dual_arm"
    
    // --- Environment ---
    deployment_prefix = local.deployment_prefix

    // --- VPC Network Configuration ---
    vpc_id = module.net.vpcid
    gateways_private_subnets = module.net.private_subnets
    gateways_public_subnets = module.net.public_subnets

    // --- Automatic Provisioning with Security Management Server Settings ---
    gateways_provision_address_type = "private"

    // tags
    management_server = "gwlb-management-server"
    configuration_template = "gwlb-ASG-configuration"

    // --- EC2 Instances Configuration ---
    gateway_instance_type = "c6in.xlarge"
    key_name = var.sshkey_name
    ip_mode = "IPv4"
    instances_tags = {
        key1 = "value1"
        key2 = "value2"
    }

    // --- Auto Scaling Configuration ---
    minimum_group_size = 2
    maximum_group_size = 3
    target_groups = ["arn:aws:tg1/abc123", "arn:aws:tg2/def456"]

    // --- Check Point Settings ---
    gateway_version = "R82-BYOL"
    admin_shell = "/etc/cli.sh"
    gateway_password_hash = ""
    gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
    gateway_SICKey = "12345678"
    enable_instance_connect = false
    allow_upload_download = true
    enable_cloudwatch = false
    gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
}