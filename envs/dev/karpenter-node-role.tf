
## Karpenter IAM Role and Instance Profile

resource "aws_iam_role" "karpenter_node_role" {
  count = var.enable_karpenter ? 1 : 0

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
  count      = var.enable_karpenter ? 1 : 0
  role       = aws_iam_role.karpenter_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni" {
  count      = var.enable_karpenter ? 1 : 0
  role       = aws_iam_role.karpenter_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  count      = var.enable_karpenter ? 1 : 0
  role       = aws_iam_role.karpenter_node_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}


resource "aws_iam_instance_profile" "karpenter_instance" {
  count = var.enable_karpenter ? 1 : 0
  name  = "karpenter-instance-profile"
  role  = aws_iam_role.karpenter_node_role[0].name
}

output "karpenter_instance_profile" {
  value = var.enable_karpenter ? aws_iam_instance_profile.karpenter_instance[0].name : null
}

resource "aws_iam_policy" "karpenter_passrole" {
  name  = "karpenter-passrole"
  count = var.enable_karpenter ? 1 : 0
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = aws_iam_role.karpenter_node_role[0].arn
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "karpenter_attach" {
  count      = var.enable_karpenter ? 1 : 0
  role       = module.eks_blueprints_addons.karpenter[0].iam_role_name
  policy_arn = aws_iam_policy.karpenter_passrole[0].arn
}
