#VPC-CNI add on is used to provide networking capabilities for Kubernetes pods in an EKS cluster.
#with this add on pods can receive IP addresses from the VPC, allowing them to communicate with other resources in the VPC and on the internet.
resource "aws_eks_addon" "vpc_cni" {
    cluster_name = var.cluster_name
    addon_name = "vpc-cni"

    configuration_values = jsonencode ({
        env = {
            ENABLE_PREFIX_DELEGATION = "true" #Enables prefix delegation for the VPC CNI plugin, allowing it to allocate multiple IP addresses to pods from a single VPC subnet.
            WARM_PREFIX_TARGET = "1" #Specifies the number of warm prefixes to maintain for pod IP address allocation, helping to reduce latency when scaling pods.
        }
    })

    resolve_conflicts_on_create = "OVERWRITE" #This setting ensures that if there are any conflicts between the existing addon configuration and the new configuration being applied, the new configuration will overwrite the existing one.
    resolve_conflicts_on_update = "OVERWRITE" #This setting ensures that if there are any conflicts between the existing addon configuration and the new configuration being applied, the new configuration will overwrite the existing one.
}