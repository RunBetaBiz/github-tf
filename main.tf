terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_repository" "repos" {
  for_each = toset(var.repositories)

  name        = each.value
  visibility  = "private" # change to "public" if needed
  description = "Terraform-managed repository: ${each.value}"
  auto_init   = true
}
