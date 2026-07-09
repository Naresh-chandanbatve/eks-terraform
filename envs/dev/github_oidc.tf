resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

data "aws_iam_policy_document" "github_oidc_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test = "StringEquals"

      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test = "StringLike"

      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {

  name = var.github_oidc_role_name

  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}


resource "aws_iam_role_policy" "github_actions" {

  name = "github-actions-policy"

  role = aws_iam_role.github_actions.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [

          "eks:DescribeCluster",

          "ecr:GetAuthorizationToken",

          "ecr:BatchCheckLayerAvailability",

          "ecr:CompleteLayerUpload",

          "ecr:UploadLayerPart",

          "ecr:InitiateLayerUpload",

          "ecr:PutImage",

          "ecr:BatchGetImage"
        ]

        Resource = "*"
      }

    ]

  })
}


resource "github_actions_secret" "aws_role_arn" {

  repository = var.github_repo

  secret_name = "AWS_ROLE_ARN"

  plaintext_value = aws_iam_role.github_actions.arn
}

resource "github_actions_secret" "backend_repository" {

  repository = var.github_repo

  secret_name = "ECR_BACKEND_REPOSITORY"

  plaintext_value = aws_ecr_repository.backend.repository_url
}

resource "github_actions_secret" "frontend_repository" {

  repository = var.github_repo

  secret_name = "ECR_FRONTEND_REPOSITORY"

  plaintext_value = aws_ecr_repository.frontend.repository_url
}

output "github_role_arn" {

  value = aws_iam_role.github_actions.arn
}

output "backend_repository" {

  value = aws_ecr_repository.backend.repository_url
}

output "frontend_repository" {

  value = aws_ecr_repository.frontend.repository_url
}
