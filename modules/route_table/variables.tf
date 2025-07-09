
variable "vpc_id" {
  description = "The ID of the VPC for the route table"
  type        = string
}

variable "name" {
  description = "The name of the route table"
  type        = string
}

variable "routes" {
  description = "List of routes to add to the route table"
  type = list(object({
    cidr_block = string
    gateway_id = string
  }))
  default = []
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the route table"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

