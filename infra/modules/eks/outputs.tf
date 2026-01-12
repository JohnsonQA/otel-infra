output "cluster_name" {
    value = aws_eks_cluster.main.name
}

#why endpoint as output? The endpoint is the URL used to communicate with the EKS cluster's API server. 
#Exposing it as an output allows other modules or users to easily access the cluster for management and operations.
output "cluster_endpoint" {
    value = aws_eks_cluster.main.endpoint
}

#why cluster_ca as output? The cluster CA (Certificate Authority) data is essential for securely connecting to the EKS cluster. 
#It is used to verify the identity of the cluster when clients (like kubectl or other applications) connect to it. By exposing it as an output, we enable other modules or users to retrieve this information easily for secure communications with the cluster.
output "cluster_ca" {
    value = aws_eks_cluster.main.certificate_authority[0].data
}

#why oidc_provider_arn as output? The OIDC provider ARN is crucial for enabling IAM roles for service accounts in the EKS cluster. 
#By exposing it as an output, other modules or users can easily reference the OIDC provider
output "oidc_provider_arn" {
    value = aws_iam_openid_connect_provider.eks.arn
}

#why oidc_provider_url as output? The OIDC provider URL is important for configuring IAM roles for service accounts in the EKS cluster. 
#By exposing it as an output, other modules or users can easily access the URL needed for
output "oidc_provider_url" {
    value = aws_iam_openid_connect_provider.eks.url
}