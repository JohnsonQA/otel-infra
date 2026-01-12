resource "kubernetes_service_account_v1" "alb_controller_sa" {
    metadata {
        name = "aws-alb-load-balancer-controller"
        namespace = "kube-system"
        
        annotations = {
            "eks.amazonaws.com/role-arn" = var.iam_role_arn #This annotation links the Kubernetes service account to the specified IAM role, allowing pods that use this service account to assume the IAM role and gain the associated permissions. 
        }

        labels = {
            "app.kubernetes.io/name" = "aws-load-balancer-controller"
        }
    }
}