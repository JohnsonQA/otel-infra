resource "aws_iam_role" "bastion_role" {
    name = "${var.project}-${var.environment}-bastion-role"
    
    #Assume_role_policy is required to specify which entities can assume this role
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow" #allow means the action is permitted
            Action = "sts:AssumeRole" #Action means the specific operation that is allowed
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

#why ssm policy over ssh? Because ssm provides better security and management features compared to traditional ssh access.
#Main Advantage of SSM over SSH is that it eliminates the need to open inbound ports, manage SSH keys, or use bastion hosts.
#SSM provides temprorary credential access, reducing the risk of compromised keys.
resource "aws_iam_role_policy_attachment" "ssm" {
    role = aws_iam_role.bastion_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#Custom policy to allow bastion to read eks cluster info
resource "aws_iam_policy" "bastion_eks_read" {
  name = "otel-dev-bastion-eks-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ]
        Resource = "*"
      }
    ]
  })
}

#Attching the custom policy to bastion role to read eks
resource "aws_iam_role_policy_attachment" "bastion_eks_read_attach" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_eks_read.arn
}

resource "aws_iam_policy" "bastion_terraform_state" {
  name = "${var.project}-${var.environment}-bastion-terraform-state"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Allow listing bucket (required for backend init)
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::otel-terraform-state-bucket"
      },

      # Allow read/write state file + lockfile
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::otel-terraform-state-bucket/dev/infra/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bastion_terraform_state_attach" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = aws_iam_policy.bastion_terraform_state.arn
}


#What is iam instance profile? An IAM instance profile is a container for an IAM role that you can use to pass role information to an EC2 instance when the instance starts.
#Why this instead IAM role directly? Because EC2 instances cannot directly assume IAM roles. Instead, they assume the roles through instance profiles.
resource "aws_iam_instance_profile" "bastion" {
    name = "${var.project}-${var.environment}-bastion-instance-profile"
    role = aws_iam_role.bastion_role.name
}
