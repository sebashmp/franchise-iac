variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "image_uri" {
  type        = string
  description = "Full ECR image URI including tag (e.g. 123456789.dkr.ecr.us-east-1.amazonaws.com/app:sha)"
}

variable "task_cpu" {
  type        = string
  description = "Fargate task CPU units (256, 512, 1024, 2048, 4096)"
  default     = "512"
}

variable "task_memory" {
  type        = string
  description = "Fargate task memory in MiB"
  default     = "1024"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS task instances to run"
  default     = 1
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Subnets where ECS tasks will be placed"
}

variable "ecs_sg_id" {
  type        = string
  description = "Security group ID for ECS tasks"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the IAM role used by the application code (DynamoDB access)"
}

variable "task_execution_role_arn" {
  type        = string
  description = "ARN of the IAM role used by the ECS agent (ECR pull + CloudWatch logs)"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group"
}

variable "dynamodb_table_franchises" {
  type        = string
  description = "Name of the franchises DynamoDB table (injected as env var into the container)"
}

variable "dynamodb_table_branches" {
  type        = string
  description = "Name of the branches DynamoDB table"
}

variable "dynamodb_table_products" {
  type        = string
  description = "Name of the products DynamoDB table"
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs"
  default     = 14
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
