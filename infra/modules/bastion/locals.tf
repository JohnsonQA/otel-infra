locals {
    user_data = var.user_data_file != "" ? file(var.user_data_file) : file("${path.module}/bastion/user_data.sh")
}