module "vpc" {
  source     = "./modules/vpc"
  tags       = var.tags
  aws_region = var.aws_region
}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  tags               = var.tags
}
