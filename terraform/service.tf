resource "aws_ecs_service" "this" {
  name        = ( length(regexall("PR",var.branch_name))>0 ? join("-", ["ix","marvel","api",trimprefix(var.branch_name,"PR-")]) : join("-", ["ix","marvel","api",var.branch_name]) )
  cluster     = aws_ecs_cluster.this.id
  launch_type = "FARGATE"

  lifecycle {
    create_before_destroy = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_port   = 80
    container_name   = ( length(regexall("PR",var.branch_name))>0 ? join("-", ["my-marvel-api",trimprefix(var.branch_name,"PR-")]) : join("-", ["my-marvel-api",var.branch_name]) )
  }

  task_definition = aws_ecs_task_definition.this.arn

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }

  desired_count = 1

  network_configuration {
    subnets          = data.aws_subnet_ids.this.ids
    security_groups  = [aws_security_group.this.id]
    assign_public_ip = true
  }

  depends_on = [aws_lb.this]


}
