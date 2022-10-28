resource "aws_lb" "this" {
  name            = ( length(regexall("PR",var.branch_name))>0 ? join("-", ["ix-marvel",trimprefix(var.branch_name,"PR-")]) : join("-", ["ix-marvel",var.branch_name]) )
  security_groups = [aws_security_group.this.id]
  subnets         = data.aws_subnet_ids.this.ids

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn

  port     = 80
  protocol = "HTTP"

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
  
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  # default_action {
  #   type = "fixed-response"

  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "This SRV is live now."
  #     status_code  = "200"
  #   }
  # }
}

resource "aws_lb_listener" "web_https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn = var.certificate_arn
  # aws_acm_certificate_validation.example.certificate_arn 
  # aws_acm_certificate_validation.my_domain.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name_prefix = "ixsoc"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.this.id

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
}
