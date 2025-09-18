variable "github_owner" {
  description = "GitHub organization or username"
  type        = string
  default     = "RunBetaBiz"
}

variable "repositories" {
  description = "List of repository names to create/manage"
  type        = list(string)
  default     = [
    "repo-one",
  //  "repo-two",
  //  "repo-three"
  ]
}

variable "protected_repos" {
  description = "Repositories that can never be destroyed"
  type        = list(string)
  default     = [
  //  "infra-core",
  //  "ml-core"
  ]
}

variable "safe_destroy" {
  description = "Archive instead of permanently delete removed repos. if false, it will destroy the repo instead of archiving it"
  type        = bool
  default     = false
}
