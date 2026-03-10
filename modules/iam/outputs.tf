output "task_role_arn" {
  description = "ARN of the ECS task role (used by the application to access DynamoDB)"
  value       = aws_iam_role.task_role.arn
}

output "task_role_name" {
  description = "Name of the ECS task role"
  value       = aws_iam_role.task_role.name
}

output "task_execution_role_arn" {
  description = "ARN of the ECS task execution role (used by ECS agent to pull image and write logs)"
  value       = aws_iam_role.task_execution_role.arn
}

output "task_execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.task_execution_role.name
}
