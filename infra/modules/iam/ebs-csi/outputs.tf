output "role_arn" {
    description = "ARN of the EBS CSI IAM Role"
    value       = aws_iam_role.ebs_csi.arn
}