resource "aws_iam_role" "alb-controller" {
    name = "${var.cluster_name}-alb-controller-role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"

        Statement = [{
            Effect = "Allow"
            Principal = {
                Federated = var.oidc_provider_arn #why this? It specifies the OIDC provider as the trusted entity that can assume this IAM role.
            }
            Action = "sts:AssumeRoleWithWebIdentity" #It allows the role to be assumed by entities authenticated via web identity tokens, such as those issued by the OIDC provider.

            Condition = {
                StringEquals = {
                    "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }   
        }]
    })
}

resource "aws_iam_role_policy" "alb-controller" {

    name = "${var.cluster_name}-alb-controller-policy"
    role = aws_iam_role.alb-controller.id
    policy = data.aws_iam_policy_document.alb_controller.json #why data source over custom policy? Using a data source for the IAM policy document allows for easier management and reuse of the policy across different modules or resources.
    #It also enables dynamic generation of the policy based on variables or conditions, enhancing flexibility and maintainability.
}