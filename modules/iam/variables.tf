variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "dynamodb_table_arns" {
  type        = list(string)
  description = "ARNs of the DynamoDB tables the application is allowed to access"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
