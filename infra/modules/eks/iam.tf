resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.cluster_name}-eks-cluster-role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = "sts:AssumeRole"
            Principal = {
                Service = "eks.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_group_role" {
   name = "${var.cluster_name}-node-role"

   assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = "sts:AssumeRole"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
   })
}

# Why toset([]) here? Because we are attaching multiple policies to the same role. toset() helps to iterate over the list of policies.
#set() will not allow duplicate values, while list() will allow duplicates.
#These policies are required for the EKS worker nodes to function properly.
#AmazonEKSWorkerNodePolicy: Allows worker nodes to join the EKS cluster.
#AmazonEKS_CNI_Policy: Allows the CNI plugin to manage networking for the pods and to enable IP address in VPC
#AmazonEC2ContainerRegistryReadOnly: Allows worker nodes to pull container images from ECR.
resource "aws_iam_role_policy_attachment" "node_policies" {
    for_each = toset([
        "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
        "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    ])

    role = aws_iam_role.eks_node_group_role.name
    policy_arn = each.value
}