# locals {
# #   domain_name = ( length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["marvel",trimprefix(var.branch_name,"PR-")]),"oscore-dev","link"]) : join(".",[join("-", ["marvel",var.branch_name]),"oscore-dev","link"]) )
#     domain_name = "oscore-dev.link"
# }

# resource "aws_acm_certificate" "my_domain" {
#   domain_name               = length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["marvel",trimprefix(var.branch_name,"PR-")]),"oscore-dev.link"]) : join(".",[join("-", ["marvel",var.branch_name]),"oscore-dev.link"])
#   subject_alternative_names = ["*.oscore-dev.link"]
#   validation_method         = "DNS"

#   tags = {
#     prj = var.project_name
#     rg = local.tag_name
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# data "aws_route53_zone" "my_domain" {
#   name         = local.domain_name
#   private_zone = false
# }

# resource "aws_route53_record" "example" {
#   for_each = {
#     for dvo in aws_acm_certificate.my_domain.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = data.aws_route53_zone.my_domain.zone_id
# }

# resource "aws_route53_record" "my_domain" {
#   zone_id = data.aws_route53_zone.my_domain.zone_id
#   name = ( length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["marvel",trimprefix(var.branch_name,"PR-")])]) : join(".",[join("-", ["marvel",var.branch_name])]) )
#   type    = "CNAME"
#   ttl     = "300"
#   records = [aws_lb.this.dns_name]
# }

# resource "aws_acm_certificate_validation" "example" {
#   certificate_arn         = aws_acm_certificate.my_domain.arn
#   validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
# }
