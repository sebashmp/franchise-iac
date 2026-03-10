# ─────────────────────────────────────────────────────────────────────────────
# Task Role — used by the APPLICATION CODE running inside the container
# to call AWS services (DynamoDB). This is what DefaultCredentialsProvider
# picks up automatically when the container runs in ECS.
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_iam_role" "task_role" {
  name        = "${var.project}-${var.environment}-task-role"
  description = "Role assumed by the ${var.project} application container in ${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "dynamodb_access" {
  name = "dynamodb-access"
  role = aws_iam_role.task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "TableAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ]
        # Scoped to exactly the 3 tables + their GSI indexes
        Resource = concat(
          var.dynamodb_table_arns,
          [for arn in var.dynamodb_table_arns : "${arn}/index/*"]
        )
      }
    ]
  })
}

# ─────────────────────────────────────────────────────────────────────────────
# Task Execution Role — used by the ECS AGENT (not the app) to:
#   - Pull the Docker image from ECR
#   - Write container logs to CloudWatch
# AWS provides a managed policy for this.
# ─────────────────────────────────────────────────────────────────────────────
resource "aws_iam_role" "task_execution_role" {
  name        = "${var.project}-${var.environment}-task-execution-role"
  description = "ECS task execution role for ${var.project} in ${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
