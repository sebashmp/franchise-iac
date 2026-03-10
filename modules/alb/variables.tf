variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "IDs of the public subnets where the ALB will be placed"
}

variable "alb_sg_id" {
  type        = string
  description = "ID of the ALB security group"
}

variable "health_check_path" {
  type        = string
  description = "Path the ALB uses to check if the container is healthy"
  default     = "/actuator/health"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
