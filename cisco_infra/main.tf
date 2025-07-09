provider "aws" {
  region = "ap-south-1" # Mumbai region
}

data "terraform_remote_state" "shared_infra" {
  backend = "s3"
  config = {
    bucket = "multivendor-project-terraform-state-20250607"
    key    = "udtest/shared/terraform.tfstate"
    region = "ap-south-1"
  }
}



resource "aws_subnet" "cisco_private_subnet" {
  vpc_id            = data.terraform_remote_state.shared_infra.outputs.vpc_id
  cidr_block        = "172.16.101.0/24"
  availability_zone = "ap-south-1a"

  tags = merge(var.common_tags, {
    Name = "ACFW-2.0-CISCO-PRIVATE-SUBNET"
  })
}

module "cisco_eni" {
  for_each = var.cisco_instances
  source          = "../modules/eni"
  subnet_id = lookup(
    data.terraform_remote_state.shared_infra.outputs.subnet_ids,
    replace(each.value.subnet_key, "_subnet_id", ""),
    null
  )
  private_ip      = each.value.management_ip
  name = "${each.value.name}-${upper(replace(each.value.subnet_key, "_subnet_id", ""))}-ENI"
  security_group_ids = [data.terraform_remote_state.shared_infra.outputs.security_group_id]
  common_tags     = var.common_tags
}

module "cisco_private_eni" {
  for_each = var.cisco_instances
  source          = "../modules/eni"
  subnet_id       = aws_subnet.cisco_private_subnet.id
  private_ip      = each.value.private_ip
  name            = "${each.value.name}-PRIVATE-ENI"
  security_group_ids = [data.terraform_remote_state.shared_infra.outputs.security_group_id]
  common_tags     = var.common_tags
}

module "cisco_instance" {
  for_each               = var.cisco_instances
  source                 = "../modules/ec2_instance"
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  name                   = each.value.name
  network_interfaces = [
    {
      network_interface_id = module.cisco_eni[each.key].eni_id
      device_index         = 0
    },
    {
      network_interface_id = module.cisco_private_eni[each.key].eni_id
      device_index         = 1
    }
  ]
  common_tags            = var.common_tags
}

module "cisco_firewall_eni" {
  for_each = { for ni in var.cisco_firewall.network_interfaces : ni.name => ni }
  source          = "../modules/eni"
  subnet_id       = each.value.subnet_key == "cisco_private" ? aws_subnet.cisco_private_subnet.id : data.terraform_remote_state.shared_infra.outputs.subnet_ids[each.value.subnet_key]
  private_ip      = each.value.private_ip
  name            = each.value.name
  security_group_ids = [data.terraform_remote_state.shared_infra.outputs.security_group_id]
  common_tags     = var.common_tags
}

module "cisco_firewall" {
  source                 = "../modules/firewall_instance"
  ami                    = var.cisco_firewall.ami
  instance_type          = var.cisco_firewall.instance_type
  key_name              = var.cisco_firewall.key_name
  associate_public_ip_address = var.cisco_firewall.associate_public_ip_address
  name                   = var.cisco_firewall.name
  network_interfaces = [
    for ni in var.cisco_firewall.network_interfaces : {
      network_interface_id = module.cisco_firewall_eni[ni.name].eni_id
      device_index         = index(var.cisco_firewall.network_interfaces.*.name, ni.name)
    }
  ]
  common_tags            = var.common_tags
}

