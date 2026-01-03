output "bastion_instance_id" {
    value = aws_instance.bastion.id
}

output "bastion_public_ip" {
    value = aws_instance.bastion.public_ip
}

output "bastion_keypair_name" {
    value = aws_instance.bastion.key_name
}