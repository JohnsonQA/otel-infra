output "addons" {
    description = "EKS Addons details"
    value = {
        coredns     = aws_eks_addon.coredns.addon_name
        kube_proxy  = aws_eks_addon.kubeproxy.addon_name
        vpc_cni     = aws_eks_addon.vpc_cni.addon_name
        ebs_csi     = aws_eks_addon.ebs_csi.addon_name
    }
}