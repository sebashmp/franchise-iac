variable "environment" {
  type        = string
  description = "Deployment environment (dev, staging, prod)"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for all resources"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project name used as prefix for all resources"
  default     = "franchise-api"
}

variable "image_uri" {
  type        = string
  description = "Full ECR image URI including tag — set by the CI/CD pipeline after docker push"
  default     = "placeholder"  # overridden by CI/CD; 'placeholder' allows terraform plan without a real image
}

variable "task_cpu" {
  type        = string
  description = "Fargate task CPU units"
  default     = "512"
}

variable "task_memory" {
  type        = string
  description = "Fargate task memory in MiB"
  default     = "1024"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS task replicas"
  default     = 1
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the two public subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
