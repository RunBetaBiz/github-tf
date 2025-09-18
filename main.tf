terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = var.github_owner
}

# ------------------------
# Protected repositories (cannot be destroyed)
# ------------------------
resource "github_repository" "protected_repos" {
  for_each = toset(var.protected_repos)

  name        = each.value
  visibility  = "private"
  description = "Terraform-managed protected repository"
  auto_init   = true

  lifecycle {
    prevent_destroy = true
  }
}

# ------------------------
# Regular repositories
# ------------------------
resource "github_repository" "repos" {
  for_each = toset([for r in var.repositories : r if !contains(var.protected_repos, r)])

  name              = each.value
  visibility        = "private"
  description       = "Terraform-managed repository"
  auto_init         = true
  archive_on_destroy = var.safe_destroy
}

# ------------------------
# Branch protection rules for main branch
# ------------------------
resource "github_branch_protection" "main" {
  for_each = toset(var.repositories)

  repository_id = contains(var.protected_repos, each.key) ? github_repository.protected_repos[each.key].node_id : github_repository.repos[each.key].node_id
  pattern       = "main"

  required_pull_request_reviews {
    dismissal_restrictions          = []
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
    required_approving_review_count = 1
  }

  enforce_admins = true
}
