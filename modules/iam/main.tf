
# EC2 IAM Role
resource "aws_iam_role" "ec2" {
  name                 = "MiniShopEC2S3Role"
  description          = "Allows EC2 instances to call AWS services on your behalf."
  max_session_duration = 3600

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

# EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2" {
  name = "MiniShopEC2S3Role"
  role = aws_iam_role.ec2.name
}

# Managed S3 Policy
resource "aws_iam_policy" "s3_image_access" {
  name = "MiniShopS3ImageAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject"
      ]
      Resource = "arn:aws:s3:::${var.frontend_bucket_name}/*"
    }]
  })
}

# Managed Policy Attachment
resource "aws_iam_role_policy_attachment" "s3_image_access" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.s3_image_access.arn
}

# EC2 ECR Inline Policy
resource "aws_iam_role_policy" "ecr_access" {
  name = "MiniShopEC2ECRAccess"
  role = aws_iam_role.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ]
      Resource = "*"
    }]
  })
}

# EC2 S3 Inline Policy
resource "aws_iam_role_policy" "s3_access" {
  name = "MiniShopS3ImageAcces"
  role = aws_iam_role.ec2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = "arn:aws:s3:::${var.frontend_bucket_name}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.frontend_bucket_name}/*"
      }
    ]
  })
}

# GitHub Actions OIDC Provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "ab9d0263244dd0326eb67015705a667e79cfe998"
  ]
}

# GitHub Actions Deployment Role
resource "aws_iam_role" "github_actions" {
  name                 = "GitHubActions-MiniShopFrontend-Deploy"
  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          "token.actions.githubusercontent.com:sub" = "repo:roshanrajan427-code@230669848/MSFrontend@1433876622:ref:refs/heads/main"
        }
      }
    }]
  })
}

# GitHub Actions S3 Deployment Policy
resource "aws_iam_role_policy" "github_frontend_deploy" {
  name = "MiniShopFrontendS3DeployPolicy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListFrontendBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = "arn:aws:s3:::${var.frontend_bucket_name}"
      },
      {
        Sid    = "UploadFrontendFiles"
        Effect = "Allow"
        Action = ["s3:PutObject"]
        Resource = [
          "arn:aws:s3:::${var.frontend_bucket_name}/index.html",
          "arn:aws:s3:::${var.frontend_bucket_name}/assets/*"
        ]
      }
    ]
  })
}
