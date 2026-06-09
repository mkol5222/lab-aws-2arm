locals {
    deployment_prefix = "chkpdemo"
    gateway_load_balancer_name = "${local.deployment_prefix}-gwlb"
        management_server = "gwlb-management-server"
    configuration_template = "gwlb-ASG-configuration"

    deploy_management_condition = true
    ipv6_enabled= false

    gateway_SICKey = "12345678"
}