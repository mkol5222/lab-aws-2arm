provider "aws" {}

module "lab" {

    source  = "git::https://github.com/CheckPointSW/terraform-aws-cloudguard-network-security.git//modules/gwlb_dual_arm?ref=1e1a2a0c525939a1cf85d129c5d44e4750aa4dba"

    // --- VPC Network Configuration ---
    vpc_id = "vpc-12345"
    gateways_private_subnets = ["subnet-123457", "subnet-123456"]
    gateways_public_subnets = ["subnet-234567", "subnet-345678"]
        
    // --- General Settings ---
    key_name = "publickey"
    ip_mode = "IPv4"
    enable_volume_encryption = true
    volume_size = 200
    enable_instance_connect = false
    disable_instance_termination = false
    allow_upload_download = true
    management_server = "gwlb-management-server"
    configuration_template = "gwlb-ASG-configuration"
    admin_shell = "/etc/cli.sh"
        
    // --- Gateway Load Balancer Configuration ---
    deployment_prefix = "chkp"
    connection_acceptance_required = false
    enable_cross_zone_load_balancing = true
        
    // --- Check Point CloudGuard IaaS Security Gateways Auto Scaling Group Configuration ---
    gateway_instance_type = "c6in.xlarge"
    minimum_group_size = 2
    maximum_group_size = 10
    gateway_version = "R82-BYOL"
    gateway_password_hash = ""
    gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
    gateway_SICKey = "12345678"
    gateways_provision_address_type = "private"
    enable_cloudwatch = false
    gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
        
    // --- Check Point CloudGuard IaaS Security Management Server Configuration ---
    management_deploy = true
    management_instance_type = "m5.xlarge"
    management_version = "R82-BYOL"
    management_password_hash = ""
    management_maintenance_mode_password_hash = "" # For R81.10 and below the management_password_hash is used also as maintenance-mode password.
    gateways_policy = "Standard"
    gateway_management = "Locally managed"
    admin_cidr = ""
    gateways_addresses = ""
        
    // --- Other parameters ---
    volume_type = "gp3"       
    existing_security_group_id = ""
}