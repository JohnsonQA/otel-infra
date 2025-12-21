resource "aws_instance" "bastion" {
    ami = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id

    vpc_security_group_ids = [var.bastion_sg_id]
    key_name = aws_key_pair.bastion_keypair.key_name

    iam_instance_profile = aws_iam_instance_profile.bastion.name
    associate_public_ip_address = true

    root_block_device {
        volume_size = var.root_volume_size
        volume_type = "gp3"
    }

    user_data = local.user_data

    tags = {
        Name = "${var.project}-${var.environment}-bastion"
        Project = var.project
        Environment = var.environment
    }
}