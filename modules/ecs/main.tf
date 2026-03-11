# ─── CloudWatch Log Group ─────────────────────────────────────────────────────
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.project}/${var.environment}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# ─── ECS Cluster ──────────────────────────────────────────────────────────────
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-cluster"
  })
}

# ─── Task Definition ──────────────────────────────────────────────────────────
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.project}"
      image     = var.image_uri
      essential = true

      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]

      # Environment variables injected into the Spring Boot container.
      # Table names come from Terraform outputs so the app always connects
      # to the correct tables for this environment without hardcoding.
      environment = [
        { name = "AWS_REGION",                  value = var.aws_region },
        { name = "DYNAMODB_TABLE_FRANCHISES",   value = var.dynamodb_table_franchises },
        { name = "DYNAMODB_TABLE_BRANCHES",     value = var.dynamodb_table_branches },
        { name = "DYNAMODB_TABLE_PRODUCTS",     value = var.dynamodb_table_products },
        { name = "SPRING_PROFILES_ACTIVE",      value = var.environment }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-task"
  })
}

# ─── ECS Service ──────────────────────────────────────────────────────────────
resource "aws_ecs_service" "app" {
  name            = "${var.project}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.project
    container_port   = 8080
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-service"
  })

  lifecycle {
    ignore_changes = [task_definition]
  }
}
