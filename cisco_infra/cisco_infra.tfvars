common_tags = {
  Project = "ACFW-2.0"
  Vendor  = "Cisco"
}

cisco_instances = {
  cisco_window_vm_01 = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.medium"
    subnet_key                  = "management_subnet_id"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = false
    name                        = "ACFW-2.0-CISCO-WINDOW-VM-01"
    management_ip               = "172.16.10.11"
    private_ip                  = "172.16.101.11"
    private_subnet_id_key       = "cisco_private_subnet_id"
  }

  cisco_window_vm_02 = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.medium"
    subnet_key                  = "management_subnet_id"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = false
    name                        = "ACFW-2.0-CISCO-WINDOW-VM-02"
    management_ip               = "172.16.10.12"
    private_ip                  = "172.16.101.12"
    private_subnet_id_key       = "cisco_private_subnet_id"
  }

  cisco_ubuntu_vm_03 = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.micro"
    subnet_key                  = "cyperf_subnet_id"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = false
    name                        = "ACFW-2.0-CISCO-UBUNTU-VM-03"
    management_ip               = "172.16.3.14"
    private_ip                  = "172.16.101.21"
    private_subnet_id_key       = "cisco_private_subnet_id"
  }

  cisco_cyperf_vm_01 = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.micro"
    subnet_key                  = "cyperf_subnet_id"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = false
    name                        = "ACFW-2.0-CISCO-CYPERF-VM-01"
    management_ip               = "172.16.3.12"
    private_ip                  = "172.16.101.22"
    private_subnet_id_key       = "cisco_private_subnet_id"
  }

  cisco_cyperf_vm_02 = {
    ami                         = "ami-0f5ee92e2d63afc18"
    instance_type               = "t2.micro"
    subnet_key                  = "cyperf_subnet_id"
    key_name                    = "ACFW2.0-ACCESS-Key"
    associate_public_ip_address = false
    name                        = "ACFW-2.0-CISCO-CYPERF-VM-02"
    management_ip               = "172.16.3.13"
    private_ip                  = "172.16.101.23"
    private_subnet_id_key       = "cisco_private_subnet_id"
  }
}

cisco_firewall = {
  ami                         = "ami-0f5ee92e2d63afc18"
  instance_type               = "c5.xlarge"
  subnet_key                  = "management_subnet_id"
  key_name                    = "ACFW2.0-ACCESS-Key"
  associate_public_ip_address = false
  name                        = "ACFW-2.0-CISCO-FIREWALL"

  network_interfaces = [
    {
      private_ip = "172.16.10.201"
      name       = "ACFW-2.0-CISCO-FIREWALL-MANAGEMENT-ENI"
      subnet_key = "management"
    },
    {
      private_ip = "172.16.3.101"
      name       = "ACFW-2.0-CISCO-FIREWALL-CYPERF-ENI"
      subnet_key = "cyperf"
    },
    {
      private_ip = "172.16.5.101"
      name       = "ACFW-2.0-CISCO-FIREWALL-PUBLIC-ENI"
      subnet_key = "public"
    },
    {
      private_ip = "172.16.101.54"
      name       = "ACFW-2.0-CISCO-FIREWALL-PRIVATE-ENI"
      subnet_key = "cisco_private"
    }
  ]
}
