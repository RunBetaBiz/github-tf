terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  # Uses GITHUB_TOKEN environment variable
  owner = var.github_owner
}

resource "github_repository" "repos" {
  for_each = toset(var.repositories)

  name        = each.value
  visibility  = "private" # change to "public" if needed
  description = "Terraform-managed repository: ${each.value}"
  auto_init   = true

  # Archive or permanently delete on destroy
  archive_on_destroy = var.safe_destroy

  # Prevent deletion for protected repos
  lifecycle {
    prevent_destroy = contains(var.protected_repos, each.value)
  }
}
