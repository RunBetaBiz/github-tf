terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  # Token is picked up automatically from the GITHUB_TOKEN environment variable
  owner = var.github_owner
}

resource "github_repository" "repos" {
  for_each = toset(var.repositories)

  name        = each.value
  visibility  = "private" # or "public"
  description = "Terraform-managed repository: ${each.value}"
  auto_init   = true

  # Behavior on destroy: archive or delete
  archive_on_destroy = var.safe_destroy
}
