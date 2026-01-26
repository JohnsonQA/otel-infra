locals {
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }
    az_names = sort(slice(data.aws_availability_zones.az_info.names, 0, 2)) #sort why? to keep the order consistent in different regions and different accounts
}