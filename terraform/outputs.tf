output "vpc" {
  value = {
    id         = module.vpc.vpc_id
    cidr_block = module.vpc.vpc_cidr_block
    private_subnets = {
      ids   = module.subnets.private_subnet_ids
      cidrs = module.subnets.private_subnet_cidrs
    }
    public_subnets = {
      ids   = module.subnets.public_subnet_ids
      cidrs = module.subnets.public_subnet_cidrs
    }
  }
}
