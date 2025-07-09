common_tags = {
  Project = "ACFW-2.0"
  Vendor  = "Shared"
}

vpc_cidr_block = "172.16.0.0/16"

subnets = {
  public = {
    cidr_block        = "172.16.5.0/24"
    availability_zone = "ap-south-1a"
    name              = "ACFW-2.0-PUBLIC-SUBNET"
  }
  management = {
    cidr_block        = "172.16.10.0/24"
    availability_zone = "ap-south-1a"
    name              = "ACFW-2.0-MANAGEMENT-SUBNET"
  }
  cyperf = {
    cidr_block        = "172.16.3.0/24"
    availability_zone = "ap-south-1a"
    name              = "ACFW-2.0-CYPERF-SUBNET"
  }
}

shared_enis = {
  jump_server_management = {
    private_ip = "172.16.10.10"
    name       = "ACFW-2.0-JUMP-SERVER-MANAGEMENT-ENI"
    subnet_key = "management"
  }
  cyperf_server_management = {
    private_ip = "172.16.10.20"
    name       = "ACFW-2.0-CYPERF-SERVER-MANAGEMENT-ENI"
    subnet_key = "management"
  }
  cyperf_server_cyperf = {
    private_ip = "172.16.3.21"
    name       = "ACFW-2.0-CYPERF-SERVER-ENI"
    subnet_key = "cyperf"
  }
}

shared_instances = {
  jump_server = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.micro"
    subnet_key                  = "management"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = true
    name                        = "ACFW-2.0-JUMP-SERVER"
    network_interfaces_keys     = ["jump_server_management"]
  }
  cyperf_server = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.micro"
    subnet_key                  = "management"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = false
    name                        = "ACFW-2.0-CYPERF-SERVER"
    network_interfaces_keys     = ["cyperf_server_management", "cyperf_server_cyperf"]
  }
}
