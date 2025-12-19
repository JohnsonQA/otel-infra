output "bastion_sg_id" {
    value = module.sg.bastion_sg_id
}

output "eks_control_plane_sg_id" {
    value = module.sg.eks_control_plane_sg_id
}

output "eks_nodes_sg_id" {
    value = module.sg.eks_nodes_sg_id
}