#kube-proxy is used to manage network routing for Kubernetes pods in an EKS cluster.
#The kube-proxy addon is responsible for maintaining network rules on each node in the cluster, allowing communication between pods and services.
resource "aws_eks_addon" "kubeproxy" {
    cluster_name = var.cluster_name
    addon_name = "kube-proxy"

    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
}