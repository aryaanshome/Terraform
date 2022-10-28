locals {
  
  tag_name = (var.branch_name != "main" ? join("-", ["RG",var.project_name,trimprefix(var.branch_name,"PR-")]) : join("-", ["RG",var.project_name,var.branch_name]))
}

terraform {
  backend "s3" {
    
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.19.0"
    }
    random = {
      source = "hashicorp/random"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.17.0"
    }
    
  }
  # cloud {
  #   organization = "Oscore"

  #   workspaces {
  #     name = "gh-actions-demo"
  #   }
  # }
  
}
