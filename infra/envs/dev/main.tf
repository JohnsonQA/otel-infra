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

module "eks_access" {
  source = "../../modules/eks-access"

  cluster_name = module.eks.cluster_name
  principal_arn = module.bastion.bastion_role_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}

module "ebs_csi_iam" {
  source = "../../modules/iam/ebs-csi"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn #These were added to pass the OIDC provider details from the EKS module to the IAM module.
  oidc_provider_url = module.eks.oidc_provider_url 
}

module "alb_controller_iam" {
  source = "../../modules/iam/alb-controller"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
}

module "alb_controller_sa" {
  source = "../../modules/kubernetes/alb-controller-sa"

  iam_role_arn = module.alb_controller_iam.iam_role_arn

  tags = {
    Environment = var.environment
    Project     = var.project
    Component = "alb-controller"
  }
}

module "eks_addons" {
  source = "../../modules/eks-addons"
  cluster_name = module.eks.cluster_name
  region = var.region

  alb_controller_enabled = var.alb_controller_enabled
  ebs_csi_role_arn = module.ebs_csi_iam.role_arn

  depends_on = [
    module.alb_controller_sa
  ]
}

module "storage_class" {
  source = "../../modules/storage/storage-class"

  cluster_name = module.eks.cluster_name

  depends_on = [module.eks_addons]
}