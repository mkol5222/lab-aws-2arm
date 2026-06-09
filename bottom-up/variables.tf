
variable "sshkey_name" {
  type        = string
  description = "The name of the SSH key pair to use for the test instances"
  default     = "m4"
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Whether to enable cross-zone load balancing for the Gateway Load Balancer"
  default     = true
}

variable "ip_mode" {
  type        = string
  description = "IP mode of AWS resources."
  default     = "IPv4"
  validation {
    condition     = contains(["IPv4", "DualStack"], var.ip_mode)
    error_message = "The ip_mode value must be one of: IPv4 or DualStack."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to use for the VPC"
  default     = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

variable "management_subnet_cidr" {
  type        = string
  description = "CIDR block for the management subnet"
  default     = "10.0.177.0/24"
}