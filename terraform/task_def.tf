resource "aws_ecs_task_definition" "this" {
  family                   = "sample_api"
  memory                   = 512
  cpu                      = 256
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task.arn
  execution_role_arn       = aws_iam_role.task.arn
  network_mode             = "awsvpc"
  container_definitions = jsonencode(
    [{
      "name" : ( length(regexall("PR",var.branch_name))>0 ? join("-", ["my-marvel-api",trimprefix(var.branch_name,"PR-")]) : join("-", ["my-marvel-api",var.branch_name]) )
      "image" : ( length(regexall("PR",var.branch_name))>0 ? join(":",[join("-", ["580990347077.dkr.ecr.eu-west-2.amazonaws.com/marvel","api",trimprefix(var.branch_name,"PR-")]),"latest100"]) : join(":",[join("-", ["580990347077.dkr.ecr.eu-west-2.amazonaws.com/marvel","api",var.branch_name]),"latest100"])),
      "portMappings" : [
        { containerPort = 80 }
      ],
    }]
  )

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
}
