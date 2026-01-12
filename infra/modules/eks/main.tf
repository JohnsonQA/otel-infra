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

    # EKS Access Configuration is set to use both API and Config Map for authentication.
    access_config {
        authentication_mode = "API_AND_CONFIG_MAP"
    }

    #why depends on here? To ensure that the IAM role policies are attached before creating the EKS cluster, preventing potential permission issues during cluster creation.
    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_policy
    ]

    tags = var.tags
}

#why this? To create an OIDC provider for the EKS cluster, enabling integration with Kubernetes service accounts for IAM roles.
resource "aws_iam_openid_connect_provider" "eks" {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer #why this? It sets the OIDC provider URL to the issuer URL of the EKS cluster, enabling integration with Kubernetes service accounts for IAM roles. Means? 
    #It allows the EKS cluster to use OIDC for authentication, facilitating secure access to AWS resources from within the cluster.

    client_id_list = ["sts:amazonaws.com"] #It specifies the allowed client IDs that can use this OIDC provider, in this case, the AWS STS service. means? It allows the EKS cluster to authenticate with AWS services using web identity tokens.

    thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint] #why this? To ensure secure communication with the OIDC provider by validating its SSL/TLS certificate using the provided thumbprint. means? 
    #It ensures that the OIDC provider is legitimate and prevents man-in-the-middle attacks.
}
