variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID"
}

variable "ipv6_enabled" {
  type        = bool
  description = "Whether IPv6 is enabled"
  default     = false
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "management_subnet_cidr" {
  type        = string
  description = "CIDR block for the management subnet"
}

variable "deployment_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "management_server" {
  type        = string
  description = "Management server name"
}

variable "sshkey_name" {
  type        = string
  description = "SSH key pair name"
}

variable "configuration_template" {
  type        = string
  description = "Configuration template name"
}

variable "gateway_SICKey" {
  type        = string
  description = "SIC key for gateway provisioning"
}
