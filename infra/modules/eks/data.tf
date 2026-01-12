# Retrieve the OIDC provider certificate for the EKS cluster
data "tls_certificate" "oidc" {
    url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}