#### Create OIDC provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

#### IAM Role for GitHub Actions to access ECR
resource "aws_iam_role" "github" {
  name = "arcampos-github-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:cleitonbarbosa21/*"
        }
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
      }
    }]
    Version = "2012-10-17"
  })
}



### IAM Policy for GitHub Actions to access ECR
resource "aws_iam_policy" "github" {
  name = "arcampos-github-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "GetAuthorizationToken"
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "AllowPushPull"
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Effect   = "Allow"
        Resource = module.eks.ecr_repository_arn
        
      },
    ]
  })
}

#### Attach IAM Policy to GitHub Role
resource "aws_iam_role_policy_attachment" "github" {
  policy_arn = aws_iam_policy.github.arn
  role       = aws_iam_role.github.name
}

output "github_actions_role_arn" {
  description = "ARN da role do GitHub Actions para acesso ao ECR"
  value       = aws_iam_role.github.arn
}