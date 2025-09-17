variable "github_owner" {
  description = "The GitHub organization name or username"
  type        = string
  default     = "RunBetaBiz"
}

variable "repositories" {
  description = "List of repository names to create"
  type        = list(string)
  default     = [
    "repo-one",
  ]
}

variable "safe_destroy" {
  description = <<EOT
If true, repositories removed from the list will be archived (safe).
If false, repositories removed will be permanently deleted (nuked).
EOT
  type    = bool
  default = true
}

variable "protected_repos" {
  description = "List of repos that can never be destroyed, even if safe_destroy = false"
  type        = list(string)
  default     = [
    "infra-core",
    "ml-core"
  ]
}
