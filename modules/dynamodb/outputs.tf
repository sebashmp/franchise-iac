output "franchises_table_name" {
  description = "Name of the franchises DynamoDB table"
  value       = aws_dynamodb_table.franchises.name
}

output "branches_table_name" {
  description = "Name of the branches DynamoDB table"
  value       = aws_dynamodb_table.branches.name
}

output "products_table_name" {
  description = "Name of the products DynamoDB table"
  value       = aws_dynamodb_table.products.name
}

output "franchises_table_arn" {
  description = "ARN of the franchises DynamoDB table"
  value       = aws_dynamodb_table.franchises.arn
}

output "branches_table_arn" {
  description = "ARN of the branches DynamoDB table"
  value       = aws_dynamodb_table.branches.arn
}

output "products_table_arn" {
  description = "ARN of the products DynamoDB table"
  value       = aws_dynamodb_table.products.arn
}

output "all_table_arns" {
  description = "List of all DynamoDB table ARNs (used to build the IAM policy)"
  value = [
    aws_dynamodb_table.franchises.arn,
    aws_dynamodb_table.branches.arn,
    aws_dynamodb_table.products.arn,
  ]
}
