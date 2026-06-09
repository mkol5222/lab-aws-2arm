variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = map(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ubuntu_password" {
  type    = string
  default = "WelcomeH0me"
}

variable "tags" {
  type    = map(string)
  default = {}
}