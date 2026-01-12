resource "aws_iam_role" "ebs_csi" {
    name = "${var.cluster_name}-ebs-csi-role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = { 
                Federated = var.oidc_provider_arn #why this? It specifies the OIDC provider as the trusted entity that can assume this IAM role.
            }

            Action = "sts:AssumeRoleWithWebIdentity" #It allows the role to be assumed by entities authenticated via web identity tokens, such as those issued by the OIDC provider.
            #Below condition restricts the role assumption to a specific service account in the EKS cluster.
            #Explain below condition with replace function what exactly it is doing? Tell -> The replace function is removing "https://" from the OIDC provider URL, allowing the condition to match the expected format for the service account.
            Condition = {
                StringEquals = {
                    "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
                }
            }
        }]
    })
}


resource "aws_iam_policy"  "ebs_csi_policy" {
    name = "${var.cluster_name}-ebs-csi-policy"
    description = "IAM policy for EBS CSI Driver to manage EBS volumes"

    policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Action = [
                "ec2:CreateVolume",
                "ec2:DeleteVolume",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:DescribeVolumes",
                "ec2:DescribeInstances",
                "ec2:CreateTags",
                "ec2:DeleteTags"
            ]
            Resource = "*" #It means the policy allows the specified actions on all resources. what resources? All EC2 volumes and instances in the AWS account.
        }]
    })
}


resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
    role       = aws_iam_role.ebs_csi.name
    policy_arn = aws_iam_policy.ebs_csi_policy.arn
}