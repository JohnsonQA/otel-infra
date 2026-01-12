#EKS Access Entry r4esource is used to grant access to an EKS cluster for a specific IAM principal.
#why this resource? This resource is essential for managing access to the EKS cluster, ensuring that only authorized IAM principals can interact with the cluster, thereby enhancing security and compliance.

resource "aws_eks_access_entry" "main" {
    cluster_name = var.cluster_name
    principal_arn = var.principal_arn #It is the Amazon Resource Name (ARN) of the IAM principal (user or role) that is being granted access to the EKS cluster.
    type = "STANDARD" #It means that the access entry is of standard type, which typically allows basic access permissions to the EKS cluster.
}

#Attach Permissions to the EKS Access Entry
#why this resource? This resource is crucial for defining the specific permissions associated with the EKS

resource "aws_eks_access_policy_association" "main" {
    cluster_name = var.cluster_name
    principal_arn = aws_eks_access_entry.main.principal_arn 

    policy_arn = var.policy_arn #It is the Amazon Resource Name (ARN) of the IAM policy that defines the permissions to be associated with the EKS access entry.

    access_scope {
        type = "cluster" #It indicates that the access scope is at the cluster level, meaning the permissions defined in the policy will apply to the entire EKS cluster.
    }
}


