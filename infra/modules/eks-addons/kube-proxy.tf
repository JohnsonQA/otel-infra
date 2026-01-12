resource "aws_eks_addon" "kubeproxy" {
    cluster_name = var.cluster_name
    addon_name = "kube-proxy"

    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
}