variable "github_owner" {
  description = "The GitHub organization or username"
  type        = string
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
