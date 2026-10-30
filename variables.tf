
variable "aws_region" {
  description = "AWS region for Mini-Shop infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "frontend_bucket_name" {
  description = "Existing Mini-Shop frontend S3 bucket"
  type        = string
  default     = "mini-shop-frontend-roshan-2026"
}

variable "backend_instance_id" {
  description = "Existing Mini-Shop backend EC2 instance ID"
  type        = string
  default     = "i-0da902e5243ee1b36"
}

variable "ecr_repository_name" {
  description = "Existing Mini-Shop ECR repository"
  type        = string
  default     = "mini-shop-backend"
}
