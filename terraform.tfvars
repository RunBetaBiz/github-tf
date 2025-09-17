# Only needed if you want to override defaults
repositories = [
  "infra-test",
  "mlops-sandbox",
  "dev-tools"
]

safe_destroy = false  # set to true to archive instead of delete
protected_repos = ["infra-core"]  # repos that can never be destroyed
