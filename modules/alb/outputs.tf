output "alb_dns_name" {
  description = "DNS name of the ALB — use this as the base URL for the API"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the target group (passed to ECS service)"
  value       = aws_lb_target_group.app.arn
}

output "listener_arn" {
  description = "ARN of the HTTP listener (ECS service depends on this)"
  value       = aws_lb_listener.http.arn
}
