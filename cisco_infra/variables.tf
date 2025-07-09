variable "common_tags" {
  type = map(string)
}

variable "cisco_instances" {
  type = map(object({
    ami                         = string
    instance_type               = string
    subnet_key                  = string
    key_name                    = string
    associate_public_ip_address = bool
    name                        = string
    management_ip               = string
    private_ip                  = string
    private_subnet_id_key       = string
  }))
}

variable "cisco_firewall" {
  type = object({
    ami                         = string
    instance_type               = string
    subnet_key                  = string
    key_name                    = string
    associate_public_ip_address = bool
    name                        = string
    network_interfaces = list(object({
      private_ip = string
      name       = string
      subnet_key = string
    }))
  })
}
