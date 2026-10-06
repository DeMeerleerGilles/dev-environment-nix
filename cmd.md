# Command cheat sheet

These short commands are configured in Zsh by this environment. Run them from
the terminal after applying the home-manager configuration.

## Everyday commands

| Short command | Runs | Notes |
| --- | --- | --- |
| `ll` | `eza -la` | List files, including hidden files, with details. |
| `cat <file>` | `bat <file>` | Display a file with syntax highlighting. |

## Terraform

| Short command | Runs |
| --- | --- |
| `tf` | `terraform` |
| `tfi` | `terraform init` |
| `tfp` | `terraform plan` |
| `tfa` | `terraform apply` |
| `tfd` | `terraform destroy` |
| `tfv` | `terraform validate` |
| `tffm` | `terraform fmt -recursive` |

For example, `tfp` previews the changes Terraform would make in the current
directory. `tfa` and especially `tfd` can change or remove infrastructure; review
the plan before confirming.

## Azure CLI

| Short command | Runs | Example |
| --- | --- | --- |
| `azl` | `az login` | `azl` |
| `azs <subscription>` | `az account set --subscription <subscription>` | `azs "My Subscription"` |
| `azw` | `az account show --query name -o tsv` | `azw` |

`azw` prints the name of the currently selected subscription. Use
`az account list --output table` to find subscription names or IDs for `azs`.

## Git and GitHub

| Short command | Runs | Example |
| --- | --- | --- |
| `gs` | `git status` | `gs` |
| `gp` | `git pull` | `gp` |
| `gco <branch>` | `git checkout <branch>` | `gco main` |
| `prc` | `gh pr create` | `prc` |
| `prv` | `gh pr view --web` | `prv` |

The Git plugin also provides its standard Oh My Zsh aliases. Run `alias` to see
the aliases available in your current shell.

