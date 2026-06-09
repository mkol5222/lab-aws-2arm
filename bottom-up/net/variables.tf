// --- VPC Network Configuration ---
variable "vpc_cidr" {
  type = string
  description = "The CIDR block of the VPC"
  default = "10.0.0.0/16"
}
variable "public_subnets_map" {
  type = map(string)
  description = "A map of pairs {availability-zone = subnet-suffix-number}. Each entry creates a subnet. Minimum 1 pairs.  (e.g. {\"us-east-1a\" = 1} ) "
}
variable "private_subnets_map" {
  type = map(string)
  description = "A map of pairs {availability-zone = subnet-suffix-number}. Each entry creates a subnet. Minimum 1 pairs.  (e.g. {\"us-east-1a\" = 2} ) "

}
variable "tgw_subnets_map" {
  type = map(string)
  description = "A map of pairs {availability-zone = subnet-suffix-number}. Each entry creates a subnet. Minimum 1 pair.  (e.g. {\"us-east-1a\" = 2} ) "
  default = {}
}
variable "subnets_bit_length" {
  type = number
  description = "Number of additional bits with which to extend the vpc cidr. For example, if given a vpc_cidr ending in /16 and a subnets_bit_length value of 4, the resulting subnet address will have length /20."
}

variable "availability_zones"{
  type = list(string)
  description = "The Availability Zones (AZs) to use for the subnets in the VPC. Select two (the logical order is preserved)"
}
variable "number_of_AZs" {
  type = number
  description = "Number of Availability Zones to use in the VPC. This must match your selections in the list of Availability Zones parameter"
  default = 2
}