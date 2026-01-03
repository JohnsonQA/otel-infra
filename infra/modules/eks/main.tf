resource "aws_eks_cluster" "main" {
    name = var.cluster_name
    version = var.kubernetes_version
    role_arn = aws_iam_role.eks_cluster_role.arn

    vpc_config {
        subnet_ids = var.private_subnet_ids
        security_group_ids = [var.eks_cluster_sg_id]
        endpoint_private_access = true #why this? To ensure that the EKS cluster API endpoint is only accessible from within the VPC for enhanced security.
        endpoint_public_access = false #why this? To prevent public access to the EKS cluster API endpoint, reducing exposure to potential threats.
    }

    #why this? To enable logging for various components of the EKS cluster, which helps in monitoring and troubleshooting.
    enabled_cluster_log_types = [
        "api",
        "audit",
        "authenticator",
        "controllerManager", #Purpose of Controller Manager logs is to monitor the activities of the controller manager component in EKS, which is responsible for managing various controllers that regulate the state of the cluster.
        "scheduler" #Scheduler logs help in tracking the scheduling decisions made by the Kubernetes scheduler, which assigns pods to nodes based on resource availability and other constraints.
    ]

    #why depends on here? To ensure that the IAM role policies are attached before creating the EKS cluster, preventing potential permission issues during cluster creation.
    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_policy
    ]

    tags = var.tags
}