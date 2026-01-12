variable "iam_role_arn" {
    type = string
    description = "The ARN of the IAM role to associate with the ALB Ingress Controller service account"
}


variable "tags" {
    description = "common tags"
    type = map(string)
    default = {}
}