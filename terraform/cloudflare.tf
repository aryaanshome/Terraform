provider "cloudflare" {
  email   = var.cloudflare_email
  api_token = var.cloudflare_token
}

resource "cloudflare_record" "live06dc02" {
  zone_id  = "${var.zone_id}"
  name    = ( length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["ix","marvel",trimprefix(var.branch_name,"PR-")])]) : join(".",[join("-", ["ix","marvel",var.branch_name])]) )
  value   = aws_lb.this.dns_name
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_access_application" "cf_app" {
  zone_id          = var.zone_id
  name             = ( length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["ix","marvel",trimprefix(var.branch_name,"PR-")])]) : join(".",[join("-", ["ix","marvel",var.branch_name])]) )
  domain           = ( length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["ix","marvel",trimprefix(var.branch_name,"PR-")]), var.domain]) : join(".",[join("-", ["ix","marvel",var.branch_name]), var.domain]) )
  session_duration = "24h"
}

resource "cloudflare_access_policy" "cf_policy" {
  application_id = cloudflare_access_application.cf_app.id
  zone_id        = var.zone_id
  name           = "ix-marvel-policy"
  precedence     = "1"
  decision       = "allow"

  include {
    email_domain = ["oscore.io", "infinox.com"]
  }
}