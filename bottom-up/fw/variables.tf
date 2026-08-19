variable "deployment_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs"
}

variable "sshkey_name" {
  type        = string
  description = "SSH key pair name"
}

variable "gateway_SICKey" {
  type        = string
  description = "SIC key for gateway provisioning"
}

variable "gateway_load_balancer_name" {
  type        = string
  description = "Name prefix for the Gateway Load Balancer"
}

variable "management_server" {
  type        = string
  description = "Management server tag value"
}

variable "configuration_template" {
  type        = string
  description = "Configuration template tag value"
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket holding the Lambda handler code"
}

variable "s3_key" {
  type        = string
  description = "S3 key of the Lambda handler code"
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Whether to enable cross-zone load balancing"
  default     = true
}

variable "ip_mode" {
  type        = string
  description = "IP mode (IPv4 or DualStack)"
  default     = "IPv4"
}
