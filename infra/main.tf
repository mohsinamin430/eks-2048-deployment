module "vpc" {
  source     = "./modules/vpc"
  tags       = var.tags
  aws_region = var.aws_region
}

module "eks" {
  source                  = "./modules/eks"
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids       = module.vpc.public_subnet_ids
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  tags                    = var.tags

  depends_on = [
    module.iam
  ]
}

module "iam" {
  source = "./modules/iam"
}

module "route53" {
  source = "./modules/route53"
}

module "helm" {
  source = "./modules/helm"

  depends_on = [
    module.eks
  ]
}