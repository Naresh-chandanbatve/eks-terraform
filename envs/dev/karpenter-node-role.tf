
## Karpenter IAM Role and Instance Profile

resource "aws_iam_role" "karpenter_node_role" {
  name = "karpenter-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_instance_profile" "karpenter_instance" {
  name = "karpenter-instance-profile"
  role = aws_iam_role.karpenter_node_role.name
}

output "karpenter_instance_profile" {
  value = aws_iam_instance_profile.karpenter_instance.name
}

resource "aws_iam_policy" "karpenter_passrole" {
  name = "karpenter-passrole"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = aws_iam_role.karpenter_node_role.arn
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "karpenter_attach" {
  role       = module.eks_blueprints_addons.karpenter.iam_role_name
  policy_arn = aws_iam_policy.karpenter_passrole.arn
}
