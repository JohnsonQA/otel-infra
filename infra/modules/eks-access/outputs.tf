output "principal_arn" {
    value = var.principal_arn
}

output "access_entry_id" {
    value = aws_eks_access_entry.main.id
}

output "policy_association_id" {
    value = aws_eks_access_policy_association.main.id
}