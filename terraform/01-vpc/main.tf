locals {
  tags = {
    Environment = "dev"
    Creator     = "Anas Kadam"
  }
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.21.1"

  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = "10.0.0.0/24"
  tags       = local.tags
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.39.0"

  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  tags                 = local.tags
}