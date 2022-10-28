resource "aws_ecs_cluster" "this" {
  name = ( length(regexall("PR",var.branch_name))>0 ? join("-", ["marvel-cluster",trimprefix(var.branch_name,"PR-")]) : join("-", ["marvel-cluster",var.branch_name]) )
  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
}
