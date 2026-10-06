#!/usr/bin/env bash
# Team dev-environment bootstrap for WSL Ubuntu.
# Usage: run this once on a fresh WSL Ubuntu install.
#   curl -fsSL https://raw.githubusercontent.com/<your-org>/<dev-env-repo>/main/bootstrap.sh | bash
set -euo pipefail

REPO_URL="git@github.com:<your-org>/<dev-env-repo>.git"   # <- change me
CLONE_DIR="$HOME/.config/dev-env"

echo "==> Installing Nix (Determinate Systems installer, WSL-friendly, multi-user)"
if ! command -v nix >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
        sh -s -- install --no-confirm
    # shellcheck disable=SC1091
    . /etc/profile.d/nix.sh
else
    echo "Nix already installed, skipping."
fi

echo "==> Enabling flakes (Determinate installer does this by default, but just in case)"
mkdir -p "$HOME/.config/nix"
grep -qxF 'experimental-features = nix-command flakes' "$HOME/.config/nix/nix.conf" 2>/dev/null || \
    echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"

echo "==> Cloning team dev-env config"
if [ ! -d "$CLONE_DIR" ]; then
    git clone "$REPO_URL" "$CLONE_DIR" 2>/dev/null || {
        echo "!! Could not git clone (no git/SSH key yet). Falling back to a temp Nix-provided git."
        nix shell nixpkgs#git -c git clone "$REPO_URL" "$CLONE_DIR"
    }
else
    echo "Config already cloned at $CLONE_DIR, pulling latest."
    git -C "$CLONE_DIR" pull
fi

echo "==> Applying home-manager configuration"
cd "$CLONE_DIR"
nix run home-manager/master -- switch --flake ".#$(whoami)@wsl" -b backup

echo "==> Done. Restart your terminal (or 'exec zsh') to pick up the new shell."
