
variable "sshkey_name" {
  type = string
  description = "The name of the SSH key pair to use for the test instances"
  default = "m4"
  }

  variable "enable_cross_zone_load_balancing" {
    type = bool
    description = "Whether to enable cross-zone load balancing for the Gateway Load Balancer"
    default = true
  }

  variable "ip_mode" {
  type = string
  description = "IP mode of AWS resources."
  default = "IPv4"
  validation {
    condition     = contains(["IPv4", "DualStack"], var.ip_mode)
    error_message = "The ip_mode value must be one of: IPv4 or DualStack."
  }
}