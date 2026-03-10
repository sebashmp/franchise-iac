locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# ─── DynamoDB Tables ──────────────────────────────────────────────────────────
module "dynamodb" {
  source = "./modules/dynamodb"

  environment = var.environment
  project     = var.project
  tags        = local.common_tags
}

# ─── ECR Repository ───────────────────────────────────────────────────────────
module "ecr" {
  source = "./modules/ecr"

  environment = var.environment
  project     = var.project
  tags        = local.common_tags
}

# ─── IAM Roles ────────────────────────────────────────────────────────────────
# task_role      → used by the app container to call DynamoDB
# execution_role → used by ECS agent to pull ECR image + write CloudWatch logs
module "iam" {
  source = "./modules/iam"

  environment         = var.environment
  project             = var.project
  dynamodb_table_arns = module.dynamodb.all_table_arns
  tags                = local.common_tags
}

# ─── Networking ───────────────────────────────────────────────────────────────
module "networking" {
  source = "./modules/networking"

  environment         = var.environment
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  tags                = local.common_tags
}

# ─── Application Load Balancer ────────────────────────────────────────────────
module "alb" {
  source = "./modules/alb"

  environment       = var.environment
  project           = var.project
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.networking.alb_sg_id
  tags              = local.common_tags
}

# ─── ECS Cluster + Service ────────────────────────────────────────────────────
module "ecs" {
  source = "./modules/ecs"

  environment             = var.environment
  project                 = var.project
  aws_region              = var.aws_region
  image_uri               = var.image_uri
  task_cpu                = var.task_cpu
  task_memory             = var.task_memory
  desired_count           = var.desired_count
  public_subnet_ids       = module.networking.public_subnet_ids
  ecs_sg_id               = module.networking.ecs_sg_id
  task_role_arn           = module.iam.task_role_arn
  task_execution_role_arn = module.iam.task_execution_role_arn
  target_group_arn        = module.alb.target_group_arn

  # Table names passed as env vars so the container always connects
  # to the tables of its own environment (dev/staging/prod)
  dynamodb_table_franchises = module.dynamodb.franchises_table_name
  dynamodb_table_branches   = module.dynamodb.branches_table_name
  dynamodb_table_products   = module.dynamodb.products_table_name

  tags = local.common_tags

  # ECS service must not register targets until the ALB listener exists.
  # depends_on lives here (not inside the module) because Terraform
  # only accepts resource/module references, not variable strings.
  depends_on = [module.alb]
}
