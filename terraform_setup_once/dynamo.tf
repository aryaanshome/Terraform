resource "aws_dynamodb_table" "terraform_locks" {
  name         = ( length(regexall("PR",var.branch_name))>0 ? join("-", ["terraform-infinox-up-and-running-locks",trimprefix(var.branch_name,"PR-")]) : join("-", ["terraform-infinox-up-and-running-locks",var.branch_name]) )
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
}