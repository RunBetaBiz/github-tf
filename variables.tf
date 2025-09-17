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
    "repo-two",
    "repo-three"
  ]
}

variable "safe_destroy" {
  description = <<EOT
If true, repositories will be archived instead of deleted when removed from the list.
If false, repositories will be PERMANENTLY deleted (nuked).
EOT
  type    = bool
  default = true
}
