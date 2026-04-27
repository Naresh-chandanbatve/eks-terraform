module "vpc" {
  source = "../../modules/vpc"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  tags = var.tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets

  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  node_groups = var.node_groups

  tags = var.tags
}


module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_ingress_nginx         = var.enable_ingress_nginx
  enable_cert_manager          = var.enable_cert_manager
  enable_metrics_server        = var.enable_metrics_server
  enable_karpenter             = var.enable_karpenter
  enable_kube_prometheus_stack = var.enable_kube_prometheus_stack
  tags                         = var.tags
  depends_on                   = [module.eks]
}