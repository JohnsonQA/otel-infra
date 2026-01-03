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