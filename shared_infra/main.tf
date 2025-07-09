provider "aws" {
  region = "ap-south-1" # Mumbai region
}

module "vpc" {
  source      = "../modules/vpc"
  cidr_block  = "172.16.0.0/16"
  name        = "ACFW-2.0-VPC"
  common_tags = var.common_tags
}

module "internet_gateway" {
  source      = "../modules/internet_gateway"
  vpc_id      = module.vpc.vpc_id
  name        = "ACFW-2.0-IGW"
  common_tags = var.common_tags
}

module "security_group" {
  source      = "../modules/security_group"
  name        = "ACFW-2.0-SG"
  description = "Shared security group for ACFW-2.0"
  vpc_id      = module.vpc.vpc_id
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  common_tags = var.common_tags
}

module "subnet" {
  for_each          = var.subnets
  source            = "../modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  name              = each.value.name
  common_tags       = var.common_tags
}

module "shared_eni" {
  for_each        = var.shared_enis
  source          = "../modules/eni"
  subnet_id       = module.subnet[each.value.subnet_key].subnet_id
  private_ip      = each.value.private_ip
  name            = each.value.name
  security_group_ids = [module.security_group.security_group_id]
  common_tags     = var.common_tags
}

module "shared_instance" {
  for_each               = var.shared_instances
  source                 = "../modules/ec2_instance"
  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  name                   = each.value.name
  network_interfaces = [for eni_key in each.value.network_interfaces_keys : {
    network_interface_id = module.shared_eni[eni_key].eni_id
    device_index         = index(each.value.network_interfaces_keys, eni_key)
  }]
  common_tags            = var.common_tags
}

module "public_route_table" {
  source      = "../modules/route_table"
  vpc_id      = module.vpc.vpc_id
  name        = "ACFW-2.0-PUBLIC-RT"
  routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.internet_gateway.igw_id
    }
  ]
  subnet_ids  = [module.subnet["public"].subnet_id,
                module.subnet["management"].subnet_id
                ]
  common_tags = var.common_tags
}
#this module is commented out because both subnet is associated with one route table above.
# module "management_route_table" {
#   source      = "../modules/route_table"
#   vpc_id      = module.vpc.vpc_id
#   name        = "ACFW-2.0-MANAGEMENT-RT"
#   routes = [
#     {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = module.internet_gateway.igw_id
#     }
#   ]
#   subnet_ids  = [module.subnet["management"].subnet_id]
#   common_tags = var.common_tags
# }

