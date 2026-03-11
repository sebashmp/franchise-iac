# ─── Application Load Balancer ────────────────────────────────────────────────
resource "aws_lb" "main" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-alb"
  })
}

# ─── Target Group ─────────────────────────────────────────────────────────────
# Points to ECS tasks (Fargate uses IP target type, not instance)
resource "aws_lb_target_group" "app" {
  name        = "${var.project}-${var.environment}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 10
    matcher             = "200"
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-tg"
  })
}

# ─── Listener ─────────────────────────────────────────────────────────────────
# HTTP on port 80, forwards to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
