variable "project" {
    description = "project name"
    type = string
}

variable "environment" {
    description = "environment name"
    type = string
}

variable "ami_id" {
    description = "AMI ID for bastion host"
    type = string
    default = ""
}

variable "instance_type" {
    description = "EC2 instance type for bastion host"
    type = string
    default = "t3.micro"
}

variable "subnet_id" {
    description = "subnet id for bastion host"
    type = string
}

variable "bastion_sg_id" {
    description = "SG for bastion host"
    type = string
}

variable "ssh_public_key_path" {
    description = "local path to ssh public key"
    type = string
}

variable "root_volume_size" {
    description = "Root volume size in GB"
    type = number
    default = 30
}

variable "user_data_file" {
    description = "user data file path"
    default = ""
    type = string
}


