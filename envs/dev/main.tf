module "vpc" {
  source = "../../modules/vpc"

  name = var.cluster_name
  cidr = "10.10.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  public_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  private_subnets = ["10.10.11.0/24","10.10.12.0/24","10.10.13.0/24"]

  tags = { Environment = "dev" }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  node_groups = {
    dev-ng = {
      instance_types = [var.instance_type]
      desired_size   = var.desired_size
      min_size       = var.min_size
      max_size       = var.max_size
    }
  }

  tags = { Environment = "dev" }
}

