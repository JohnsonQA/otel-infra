#This add on is used to deploy the AWS Load Balancer Controller in an EKS cluster using Helm.
#The AWS Load Balancer Controller is responsible for managing AWS Elastic Load Balancers (ELBs) for Kubernetes services and Ingress resources.
#It automates the provisioning and management of Application Load Balancers (ALBs) and Network Load Balancers (NLBs) based on the Kubernetes resources defined in the cluster.
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
            vpcId = var.vpc_id

            serviceAccount = {
                create = false
                name = "aws-load-balancer-controller" #This specifies the name of the existing Kubernetes service account to be used by the ALB Ingress Controller.
            }

            replicaCount = 2 #This sets the number of replicas (instances) of the ALB Ingress Controller to be deployed. Having multiple replicas enhances availability and fault tolerance.
        })
    ]
}