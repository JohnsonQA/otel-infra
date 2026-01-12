resource "aws_eks_addon" "coredns" {
    cluster_name = var.cluster_name
    addon_name = "coredns"

    resolve_conflicts_on_create = "OVERWRITE" #This setting ensures that if there are any conflicts between the existing addon configuration and the new configuration being applied, the new configuration will overwrite the existing one."
    resolve_conflicts_on_update = "OVERWRITE" #This setting ensures that if there are any conflicts between the existing addon configuration and the new configuration being applied, the new configuration will overwrite the existing one."
}