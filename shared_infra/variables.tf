variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}

variable "subnets" {
  description = "Subnet configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}

variable "shared_enis" {
  description = "Shared ENIs configuration"
  type = map(object({
    private_ip = string
    name       = string
    subnet_key = string
  }))
}

variable "shared_instances" {
  description = "Shared EC2 instances configuration"
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_key                  = string
    key_name                    = string
    associate_public_ip_address = bool
    name                        = string
    network_interfaces_keys     = list(string)
  }))
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
