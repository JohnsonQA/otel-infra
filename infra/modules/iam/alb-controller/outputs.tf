output "iam_role_arn" {
    value = aws_iam_role.alb-controller.arn
    description = "The ARN of the IAM role for the ALB Controller"
}