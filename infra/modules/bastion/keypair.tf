resource "aws_key_pair" "bastion_keypair" {
    key_name = "${var.project}-${var.environment}-bastion-key"
    public_key = file(var.ssh_public_key_path)

    # #what this below block does is to prevent accidental deletion of the key pair from AWS
    # lifecycle {
    #     prevent_destroy = true
    # }
}