variable "deployment_prefix" {
  type        = string
  description = "Prefix for resource names."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where VM subnets and the test instance are deployed."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the project VPC."
}

variable "internet_gateway_id" {
  type        = string
  description = "Internet Gateway ID attached to the project VPC."
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones where vm-subnet-* subnets and GWLBe endpoints are created."
}

variable "gwlb_service_name" {
  type        = string
  description = "Gateway Load Balancer endpoint service name."
}

variable "sshkey_name" {
  type        = string
  description = "Existing EC2 key pair name for the Ubuntu instance."
}

variable "vm_subnet_netnums" {
  type        = map(number)
  description = "Per-AZ subnet numbers used with cidrsubnet(vpc_cidr, subnet_newbits, netnum)."
  default = {
    "eu-north-1a" = 21
    "eu-north-1b" = 22
    "eu-north-1c" = 23
  }
}

variable "subnet_newbits" {
  type        = number
  description = "Additional CIDR bits for vm-subnet-* subnets."
  default     = 8
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the Ubuntu egress test VM."
  default     = "t3.micro"
}

variable "instance_architecture" {
  type        = string
  description = "CPU architecture for the Ubuntu AMI lookup."
  default     = "x86_64"
}

variable "ubuntu_ami_name_filter" {
  type        = string
  description = "AMI name filter for Ubuntu LTS."
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-*-server-*"
}

variable "ubuntu_password" {
  type        = string
  description = "Password set on the ubuntu user for this lab VM."
  default     = "WelcomeH0me"
  sensitive   = true
}

variable "ssh_ingress_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH to the Ubuntu test VM."
  default     = ["0.0.0.0/0"]
}