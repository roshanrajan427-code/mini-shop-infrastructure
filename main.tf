
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------
# S3 MODULE
# --------------------------------

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.frontend_bucket_name
}

moved {
  from = aws_s3_bucket.frontend
  to   = module.s3.aws_s3_bucket.frontend
}

moved {
  from = aws_s3_bucket_website_configuration.frontend
  to   = module.s3.aws_s3_bucket_website_configuration.frontend
}

moved {
  from = aws_s3_bucket_policy.frontend
  to   = module.s3.aws_s3_bucket_policy.frontend
}

moved {
  from = aws_s3_bucket_public_access_block.frontend
  to   = module.s3.aws_s3_bucket_public_access_block.frontend
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.frontend
  to   = module.s3.aws_s3_bucket_server_side_encryption_configuration.frontend
}

# --------------------------------
# ECR MODULE
# --------------------------------

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.ecr_repository_name
}

moved {
  from = aws_ecr_repository.backend
  to   = module.ecr.aws_ecr_repository.backend
}

# --------------------------------
# IAM MODULE
# --------------------------------

module "iam" {
  source = "./modules/iam"

  frontend_bucket_name = var.frontend_bucket_name
}

# EC2 IAM Role
moved {
  from = aws_iam_role.ec2
  to   = module.iam.aws_iam_role.ec2
}

# EC2 Instance Profile
moved {
  from = aws_iam_instance_profile.ec2
  to   = module.iam.aws_iam_instance_profile.ec2
}

# Managed S3 Policy
moved {
  from = aws_iam_policy.s3_image_access
  to   = module.iam.aws_iam_policy.s3_image_access
}

# Managed Policy Attachment
moved {
  from = aws_iam_role_policy_attachment.s3_image_access
  to   = module.iam.aws_iam_role_policy_attachment.s3_image_access
}

# EC2 ECR Inline Policy
moved {
  from = aws_iam_role_policy.ecr_access
  to   = module.iam.aws_iam_role_policy.ecr_access
}

# EC2 S3 Inline Policy
moved {
  from = aws_iam_role_policy.s3_access
  to   = module.iam.aws_iam_role_policy.s3_access
}

# GitHub OIDC Provider
moved {
  from = aws_iam_openid_connect_provider.github
  to   = module.iam.aws_iam_openid_connect_provider.github
}

# GitHub Actions IAM Role
moved {
  from = aws_iam_role.github_actions
  to   = module.iam.aws_iam_role.github_actions
}

# GitHub Actions Deployment Policy
moved {
  from = aws_iam_role_policy.github_frontend_deploy
  to   = module.iam.aws_iam_role_policy.github_frontend_deploy
}

# --------------------------------
# EC2 MODULE
# --------------------------------

module "ec2" {
  source = "./modules/ec2"

  instance_profile_name = module.iam.instance_profile_name
}

moved {
  from = aws_security_group.backend
  to   = module.ec2.aws_security_group.backend
}

moved {
  from = aws_instance.backend
  to   = module.ec2.aws_instance.backend
}
