locals {
    deployment_prefix = "chkpdemo"
    gateway_load_balancer_name = "${local.deployment_prefix}-gwlb"
        management_server = "gwlb-management-server"
    configuration_template = "gwlb-ASG-configuration"
}