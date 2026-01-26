#This add on is used for serving DNS records for Kubernetes services within an EKS cluster.
#CoreDNS is a critical component of Kubernetes that provides DNS-based service discovery, allowing pods to resolve the names of other services and endpoints within the cluster.
#By deploying CoreDNS as an addon in EKS, we ensure that the cluster has a reliable and scalable DNS service that can handle the dynamic nature of Kubernetes workloads.

resource "aws_eks_addon" "coredns" {
    cluster_name = var.cluster_name
    addon_name = "coredns"

    resolve_conflicts_on_create = "OVERWRITE" #This setting ensures that if there are any conflicts between the existing addon configuration and the new configuration being applied, the new configuration will overwrite the existing one."
    resolve_conflicts_on_update = "OVERWRITE" #This setting ensures that if there are any conflicts between the existing addon configuration and the new configuration being applied, the new configuration will overwrite the existing one."
}