# GitHub Repository Manager with Terraform

This repository provides a Terraform-based framework to **create, manage, and optionally delete or archive GitHub repositories** under an organization or personal account. It supports:

- Creating multiple repositories from a list.
- Archiving or permanently deleting repositories when removed from the list.
- Protecting critical repositories from accidental deletion.
- Easy configuration via variables and environment variables.

---

## 🔹 Prerequisites

1. **Terraform**  
   Install Terraform on your system. For WSL/Ubuntu:
   ```bash
   sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt-get update && sudo apt-get install -y terraform
   terraform -version

2. GitHub Personal Access Token (PAT)
Terraform interacts with the GitHub API using a token.

Go to GitHub → Settings → Developer settings → Personal access tokens
.

Create a token with repo permissions (and admin:org if managing org repos).

Do not commit your token!

3. SSH key (optional)
For cloning/pushing Terraform code using GitHub, configure an SSH key.


🔹 Setup

1. Clone this repo

git clone git@github.com:RunBetaBiz/github-tf.git
cd github-tf


2. Set your GitHub token as an environment variable

export GITHUB_TOKEN="ghp_yourtokenhere"


You can add this line to ~/.bashrc or ~/.zshrc for persistent usage.

3. Optional: terraform.tfvars
Create a terraform.tfvars file to override defaults:

repositories = [
  "infra-test",
  "mlops-sandbox",
  "dev-tools"
]

safe_destroy = false  # true = archive on removal, false = permanent delete
protected_repos = ["infra-core"]  # repos that can never be destroyed

VARIABLES
Variable	Description	Default
github_owner	GitHub org or username	"RunBetaBiz"
repositories	List of repositories to create	["repo-one","repo-two","repo-three"]
safe_destroy	Archive (true) or permanently delete (false) removed repos	true
protected_repos	List of repos that cannot be destroyed	["infra-core","ml-core"]

USAGE

Initialize Terraform

terraform init


Preview planned changes

terraform plan


Apply changes

terraform apply


Confirm with yes. Terraform will:

Create missing repositories.

Archive or delete removed repositories (based on safe_destroy).

Never destroy repos listed in protected_repos.

HOW IT WORKS

Repositories listed in repositories will be created if they do not exist.

Repositories removed from the list:

safe_destroy = true → archived (recoverable)

safe_destroy = false → permanently deleted, unless in protected_repos

Repositories in protected_repos cannot be destroyed under any circumstance.

Git operations (clone/push) can use SSH or HTTPS, but Terraform always requires a GitHub token.

NOTES FOR USERS

Safe defaults:

safe_destroy = true archives repos instead of deleting.

protected_repos ensures critical repos are never destroyed.

Adding new repos: Simply add the repo name to repositories and run terraform apply.

Deleting repos: Remove the repo name from repositories and run terraform apply. Action depends on safe_destroy.


---- ---- How the branch protection works:

Pattern: main → applies only to the main branch.

Pull Request Reviews:

At least 1 approving review is required to merge.

Stale reviews are dismissed automatically if the branch is updated.

Push Restrictions:

No direct push allowed, including admins (enforce_admins = true).

Users/Teams:

Empty lists means no one can bypass restrictions manually.


---- Notes

You must run terraform apply after repo creation so that the github_branch_protection resource has access to the repo’s node_id.

Protected repos still cannot be destroyed; branch protection applies to all repositories listed.

Future enhancements can include specifying teams that can approve PRs.