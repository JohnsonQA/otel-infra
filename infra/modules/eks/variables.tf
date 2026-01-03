variable "cluster_name" {
    type = string
}

variable "kubernetes_version" {
    type = string
    default = "1.29"
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "eks_cluster_sg_id" {
    type = string
}

variable "bastion_sg_id" {
    type = string
}


#what is map(object) here? It is a complex type that allows us to define a map where each value is an object with specific attributes.
#why we use map here? Because we want to define multiple node groups, each with its own configuration.
#Using map allows us to easily reference each node group by its name.
#why scaling config is an object? Because it groups related attributes (desired_size, max_size, min_size) together, making it easier to manage and understand.
#This structure provides clarity and organization to the node group configurations.
variable "node_groups" {
    description = "EKS node groups configuartion to use for the cluster"
    type = map(object({
        instance_types = list(string)
        capacity_type = string
        scaling_config = object({
            desired_size = number
            max_size = number
            min_size = number
        })
    }))
}

variable "tags" {
    type = map(string)
}