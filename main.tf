provider "aws" {}

module "lab" {

    source  = "./modules/tgw_gwlb_dual_arm_master"


    // --- VPC Network Configuration ---
    vpc_cidr = "10.0.0.0/16"
    public_subnets_map = {
     "eu-north-1a" = 1
     "eu-north-1b" = 2
     "eu-north-1c" = 3
     
    }
    private_subnets_map = {
     "eu-north-1a" = 9
     "eu-north-1b" = 10
     "eu-north-1c" = 11
     
    }
    tgw_subnets_map = {
     "eu-north-1a" = 5
     "eu-north-1b" = 6
     "eu-north-1c" = 7
     
    }
    subnets_bit_length = 8
      
    availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
    number_of_AZs = 3
        
    gwlbe_subnet_1_cidr = "10.0.14.0/24"
    gwlbe_subnet_2_cidr = "10.0.24.0/24"
    gwlbe_subnet_3_cidr = "10.0.34.0/24"
    gwlbe_subnet_4_cidr = "10.0.44.0/24" 
        
    // --- General Settings ---
    key_name = "m4"
    enable_volume_encryption = true
    volume_size = 200
    enable_instance_connect = false
    disable_instance_termination = false
    allow_upload_download = true
    management_server = "CP-Management-gwlb-tf"
    configuration_template = "gwlb-configuration"
    admin_shell = "/etc/cli.sh"
        
    // --- Gateway Load Balancer Configuration ---
    deployment_prefix = "chkp"
    enable_cross_zone_load_balancing = true
        
    // --- Check Point CloudGuard IaaS Security Gateways Auto Scaling Group Configuration ---
    gateway_instance_type = "c5.xlarge"
    minimum_group_size = 2
    maximum_group_size = 10
    gateway_version = "R82-BYOL"
     # AdminIzK1ng
    gateway_password_hash = "$6$DHQpTr08lvGpgnVW$vzx/uMa9/gyR.ZOKGHa6pe8l6Cim.UX9q6Nv.7VCUJTR9TF9OZUsPkd2Yvt21O9epyhVj/Ig9bnqma8uawrD70"
    gateway_maintenance_mode_password_hash = "" # For R81.10 and below the gateway_password_hash is used also as maintenance-mode password.
    gateway_SICKey = "12345678"
    gateways_provision_address_type = "private"
    enable_cloudwatch = false
    gateway_bootstrap_script = "echo 'this is bootstrap script' > /home/admin/bootstrap.txt"
        
    // --- Check Point CloudGuard IaaS Security Management Server Configuration ---
    management_deploy = true
    management_instance_type = "m5.xlarge"
    management_version = "R82-BYOL"
    # AdminIzK1ng
    management_password_hash = "$6$DHQpTr08lvGpgnVW$vzx/uMa9/gyR.ZOKGHa6pe8l6Cim.UX9q6Nv.7VCUJTR9TF9OZUsPkd2Yvt21O9epyhVj/Ig9bnqma8uawrD70"
    management_maintenance_mode_password_hash = "" # For R81.10 and below the management_password_hash is used also as maintenance-mode password.
    gateways_policy = "Standard"
    gateway_management = "Locally managed"
    admin_cidr = "0.0.0.0/0"
    gateways_addresses = "0.0.0.0/0"
        
    // --- Other parameters ---
    volume_type = "gp3"
}