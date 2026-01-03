variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.22.0/24"]
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDR block allowed to SSH into bastion"
}

variable "ssh_public_key_path" {
  type        = string
  description = "local path to ssh public key"
}

variable "instance_type" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_groups" {
  description = "EKS node groups configuartion to use for the cluster"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}