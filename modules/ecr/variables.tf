variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "image_retention_count" {
  type        = number
  description = "Number of images to retain per repository"
  default     = 10
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
