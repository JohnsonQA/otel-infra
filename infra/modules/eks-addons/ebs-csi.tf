#EBS CSI is used to manage EBS volumes for Kubernetes pods in an EKS cluster.
#The EBS CSI driver allows Kubernetes to dynamically provision and manage EBS volumes as persistent storage for applications running in the cluster.

resource "aws_eks_addon" "ebs_csi" {
    cluster_name = var.cluster_name
    addon_name = "aws-ebs-csi-driver"

    service_account_role_arn = var.ebs_csi_role_arn

    resolve_conflicts_on_create = "OVERWRITE"
    resolve_conflicts_on_update = "OVERWRITE"
}