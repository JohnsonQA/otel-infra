## IAM Policy Document for ALB Ingress Controller
# This policy grants necessary permissions for the ALB Ingress Controller to manage AWS resources.
#why data source over custom policy? Using a data source for the IAM policy document allows for easier management and reuse of the policy across different modules or resources. 
#It also enables dynamic generation of the policy based on variables or conditions, enhancing flexibility and maintainability.
data "aws_iam_policy_document" "alb_controller" {

    statement {
        effect = "Allow"

        actions = [
            "elasticloadbalancing:*",
            "ec2:Describe*",
            "ec2:CreateSecurityGroup",
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupIngress",
            "iam:CreateServiceLinkedRole",
            "wafv2:*",
            "shield:*"
        ]

        resources = ["*"]
    }  
}