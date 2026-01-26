resource "aws_eks_node_group" "main" {
    for_each = var.node_groups

    cluster_name = aws_eks_cluster.main.name
    node_group_name = "${var.cluster_name}-${each.key}"
    node_role_arn = aws_iam_role.eks_node_group_role.arn
    subnet_ids = var.private_subnet_ids

    instance_types = each.value.instance_types
    capacity_type = each.value.capacity_type

    #what this ami_type means? It specifies the type of Amazon Machine Image (AMI) to use for the EKS worker nodes.
    #Why AL2_x86_64? It indicates that we are using the Amazon Linux 2 AMI optimized for x86_64 architecture, which is a common choice for EKS worker nodes due to its compatibility and performance.
    ami_type = "AL2_x86_64"

    scaling_config {
        desired_size = each.value.scaling_config.desired_size
        max_size = each.value.scaling_config.max_size
        min_size = each.value.scaling_config.min_size
    }

    # This is not required and we shouldn't ssh into eks nodes
    /* remote_access {
        ec2_ssh_key = var.ssh_key_name
        source_security_group_ids = [var.bastion_sg_id]
    } */

    depends_on = [
        aws_eks_cluster.main,
        aws_iam_role_policy_attachment.node_policies
    ]

    tags = merge(
        var.tags,
        {
            "NodeGroup" = each.key
        }
    )
}