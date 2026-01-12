output "bastion_sg_id" {
  value = module.sg.bastion_sg_id
}

output "eks_control_plane_sg_id" {
  value = module.sg.eks_control_plane_sg_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "alb_controller_iam_role_arn" {
  value = module.alb_controller_iam.iam_role_arn
}