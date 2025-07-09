
variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = null
}

# variable "subnet_id" {
#   description = "The ID of the subnet to launch the instance in"
#   type        = string
# }

# variable "security_group_ids" {
#   description = "A list of security group IDs to associate with the instance"
#   type        = list(string)
#   default     = []
# }

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the instance"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "network_interfaces" {
  description = "A list of network interfaces to attach to the instance"
  type = list(object({
    network_interface_id = string
    device_index         = number
  }))
  default = []
}

