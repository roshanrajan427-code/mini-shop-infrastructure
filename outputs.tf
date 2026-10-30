output "frontend_bucket_name" {
  description = "Mini-Shop frontend S3 bucket"
  value       = module.s3.bucket_id
}

output "ecr_repository_url" {
  description = "Mini-Shop backend ECR repository URL"
  value       = module.ecr.repository_url
}

output "ec2_instance_id" {
  description = "Mini-Shop backend EC2 instance ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "Mini-Shop backend public IP"
  value       = module.ec2.public_ip
}

output "security_group_id" {
  description = "Mini-Shop backend security group ID"
  value       = module.ec2.security_group_id
}

output "ec2_iam_role_arn" {
  value = module.iam.ec2_role_arn
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}