
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

