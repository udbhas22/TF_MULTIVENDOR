
variable "subnet_id" {
  description = "The ID of the subnet to create the ENI in"
  type        = string
}

variable "private_ip" {
  description = "The private IP address for the ENI"
  type        = string
}

variable "name" {
  description = "The name of the ENI"
  type        = string
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the ENI"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

