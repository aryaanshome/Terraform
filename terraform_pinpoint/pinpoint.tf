resource "aws_pinpoint_sms_channel" "sms" {
  application_id = aws_pinpoint_app.app.application_id
  sender_id = ( length(regexall("PR",var.branch_name))>0 ? "PR" : var.branch_name )
}

resource "aws_pinpoint_app" "app" {
  name = ( length(regexall("PR",var.branch_name))>0 ? "PR" : var.branch_name )

  limits {
    maximum_duration = 600
    messages_per_second = 60
  }

  tags = {
    prj = var.project_name
    rg = local.tag_name
  }

  quiet_time {
    start = "00:00"
    end   = "06:00"
  }
}