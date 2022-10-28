output "url" {
  value = ["http://${aws_lb.this.dns_name}/swagger","https://${( length(regexall("PR",var.branch_name))>0 ? join(".",[join("-", ["ix","marvel",trimprefix(var.branch_name,"PR-")])]) : join(".",[join("-", ["ix","marvel",var.branch_name])]) )}.ixfin.tech/swagger"]
  # value = var.branch_name

}
