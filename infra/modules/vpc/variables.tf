variable "vpc_cidr" {
    description = "CIDR block for VPC"
    type = string
}

variable "public_subnet_cidrs" {
    description = "CIDR block for public subnets"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "CIDR block for private subnets"
    type = list(string)
}

variable "project" {
    description = "project name"
    type = string
}

variable "environment" {
    description = "environment name"
    type = string
}