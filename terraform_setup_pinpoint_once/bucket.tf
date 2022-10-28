resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = ( length(regexall("PR",var.branch_name))>0 ? join("-", ["terraform-infinox-pinpoint-state-pr"]) : join("-", ["terraform-infinox-pinpoint-state",var.branch_name]) )
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = false
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    prj = var.project_name
    rg = local.tag_name
  }
}