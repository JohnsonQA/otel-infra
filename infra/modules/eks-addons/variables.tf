variable "cluster_name" {
    type = string
    description = "The name of the EKS cluster"
}

variable "ebs_csi_role_arn" {
    type = string
    description = "The ARN of the IAM role for the EBS CSI driver"
}

variable "region" {
    description = "The AWS region where the EKS cluster is deployed"
    type = string
}

variable "vpc_id" {
    description = "The ID of the VPC where the EKS cluster is deployed"
    type        = string
}

variable "alb_controller_enabled" {
    description = "Flag to enable or disable the ALB Ingress Controller addon"
    type        = bool
    default     = true
}