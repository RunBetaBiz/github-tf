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

# Create repositories
resource "github_repository" "repos" {
  for_each = toset(var.repositories)

  name        = each.value
  visibility  = "private"
  description = "Terraform-managed repository: ${each.value}"
  auto_init   = true
  archive_on_destroy = var.safe_destroy

  lifecycle {
    prevent_destroy = contains(var.protected_repos, each.value)
  }
}

# Branch protection rules
resource "github_branch_protection" "main" {
  for_each = toset(var.repositories)

  repository_id = github_repository.repos[each.key].node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismissal_restrictions = []
    dismiss_stale_reviews  = true
    require_code_owner_reviews = false
    required_approving_review_count = 1
  }

  restrictions {
    users = []
    teams = []
  }

  enforce_admins = true
}
