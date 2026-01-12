resource "helm_release" "alb_controller" {
    count = var.alb_controller_enabled ? 1 : 0

    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    repository = "https://aws.github.io/eks-charts"
    chart = "aws-load-balancer-controller"
    version = "1.7.1"

    create_namespace = false

    values = [
        yamlencode({
            clusterName = var.cluster_name
            region = var.region

            serviceAccount = {
                create = false
                name = "aws-load-balancer-controller" #This specifies the name of the existing Kubernetes service account to be used by the ALB Ingress Controller.
            }

            replicaCount = 2
        })
    ]
}