#!/bin/bash
set -e

apt update -y
apt install -y curl unzip git jq docker.io cloud-guest-utils

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
unzip awscliv2.zip
./aws/install

# Terraform
curl -fsSL https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip -o terraform.zip
unzip terraform.zip
mv terraform /usr/local/bin/

# kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

# eksctl
curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin/

# Resize disk
growpart /dev/nvme0n1 1 || true
resize2fs /dev/nvme0n1p1 || resize2fs /dev/nvme0n1 || true
