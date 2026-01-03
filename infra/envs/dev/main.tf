module "vpc" {
  source = "../../modules/vpc"

  project              = var.project
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "sg" {
  source = "../../modules/sg"

  project     = var.project
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr

  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

module "bastion" {
  source = "../../modules/bastion"

  project       = var.project
  environment   = var.environment
  subnet_id     = module.vpc.public_subnet_ids[0]
  bastion_sg_id = module.sg.bastion_sg_id
  instance_type = var.instance_type

  ssh_public_key_path = var.ssh_public_key_path
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "${var.project}-${var.environment}-eks"
  kubernetes_version = var.kubernetes_version

  private_subnet_ids = module.vpc.private_subnet_ids
  eks_cluster_sg_id  = module.sg.eks_control_plane_sg_id
  bastion_sg_id      = module.sg.bastion_sg_id

  node_groups = var.node_groups

  tags = {
    Environment = var.environment
    Project     = var.project
  }
}