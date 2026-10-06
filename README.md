# Team Dev Environment (WSL Ubuntu + Nix + home-manager)

Nix based development environment for the team. This repo is cloned and applied by new team members on their WSL Ubuntu machine.

## What a new team member does

1. Install WSL Ubuntu on the machine of the user (if not already): `wsl --install -d Ubuntu` on Windows.
2. Inside the WSL Ubuntu terminal, run:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/DeMeerleerGilles/dev-environment-nix/refs/heads/main/bootstrap.sh | bash
   ```

3. Once it finishes: `chsh -s $(which zsh)`, then restart the terminal.

That's it — `git`, `gh`, `az`, `terraform`, `kubectl`, zsh with plugins/theme,
and the team's git/gh defaults are all installed and configured.

## What's in this repo

- `flake.nix` — entrypoint; declares one `homeConfiguration` per team member
  username. Add new hires here.
- `home.nix` — the actual environment: packages, git config, gh config, zsh
  + oh-my-zsh + starship.
- `bootstrap.sh` — one-shot script a new machine runs: installs Nix, clones
  this repo, applies the config.

## Customizing your own git identity

`home.nix` ships with placeholder git user/email. Two options:

- **Simplest:** each person edits their own name/email in `home.nix` locally
  before running `home-manager switch` again (not committed upstream), or
- **Cleaner:** split personal identity into `~/.config/git/local.nix`
  (untracked) and `programs.git.includes` to pull it in — ask in #dev-tooling
  if you want this wired up.

## Updating the team environment

1. Edit `home.nix` (add a package, change a zsh plugin, etc.), open a PR.
2. Once merged, everyone runs:

   ```bash
   cd ~/.config/dev-env && git pull
   nix run home-manager/master -- switch --flake ".#$(whoami)@wsl"
   ```

   (or just re-run `bootstrap.sh`, it pulls + re-applies automatically).

## Rolling back

home-manager keeps generations. If an update breaks something:

```bash
nix run home-manager/master -- switch --flake ".#$(whoami)@wsl" --rollback
```

## Adding a new team member

Add their WSL username to the list in `flake.nix`:

```nix
[ "gilles" "alice" "bob" "new-person" ]
```

Merge, and their `bootstrap.sh` run will just work.
