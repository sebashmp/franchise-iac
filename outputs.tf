output "alb_dns_name" {
  description = "Public URL of the API: http://<alb_dns_name>/api/v1/..."
  value       = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  description = "ECR repository URL — used by CI/CD to push Docker images"
  value       = module.ecr.repository_url
}

output "dynamodb_franchises_table_name" {
  description = "Name of the franchises DynamoDB table"
  value       = module.dynamodb.franchises_table_name
}

output "dynamodb_branches_table_name" {
  description = "Name of the branches DynamoDB table"
  value       = module.dynamodb.branches_table_name
}

output "dynamodb_products_table_name" {
  description = "Name of the products DynamoDB table"
  value       = module.dynamodb.products_table_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service — used by CI/CD to trigger deployments"
  value       = module.ecs.service_name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for container logs"
  value       = module.ecs.log_group_name
}

output "ecs_task_role_arn" {
  description = "ARN of the task role (app permissions — DynamoDB access)"
  value       = module.iam.task_role_arn
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the task execution role (ECR pull + CloudWatch logs)"
  value       = module.iam.task_execution_role_arn
}
