variable "cluster_name" {
    description = "EKS cluster name"
    type = string
}

variable "principal_arn" {
    description = "ARN of the IAM principal (user or role) to grant access"
    type = string
}

variable "policy_arn" {
    description = "ARN of the IAM policy to attach"
    type = string
}