# Nixos on WSL

## Requirements

First make sure you have WSL installed on your machine. You can download this easily from the company portal app on your PC. You find it under apps > windows subsystem for linux. You wil have to perform a restart for the installation to complete since it is a windows feature.

Now that you have WSL installed, we will install ubuntu. Please note that you will need admin privileges. Run the following command in powershell to install the ubuntu for WSL:

```powershell
wsl --install -d Ubuntu-24.04
```

You will be promted to create a user and password for ubuntu. After you set this, you will have an ubuntu terminal.

## Change DNS settings

Now we will change the DNS settings. First add the following lines to the wsl.conf file:

```bash
sudo nano /etc/wsl.conf
```

Add this to the file:

```ini
[network]
generateResolvConf = false
```

Delete the existing /etc/resolv.conf by running `sudo rm /etc/resolv.conf` and recreate that file with `sudo nano /etc/resolv.conf`

Add the following lines to the resolv.conf file:

```bash
search brussels.airport
nameserver 10.108.108.100
nameserver 10.108.108.200
nameserver 208.67.222.222
nameserver 208.67.220.220
```

Save & exit the file.

Now generate an ssh key pair if you don't have one already:

```bash
ssh-keygen
```

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix run home-manager/master -- init --switch
```

Add your public key to your bitbucket account under account.


Clone the repo using the following command:

```bash
git clone ssh://git@bitbucket.brusselsairport.be:22/ictcf/wsl-nixos.git
cd wsl-nixos/
```

Open flake.nix and add your name to the file. Copy a home file from the directory of another user and change the username to your username.

```bash
cd hosts/
ls
```

You should see a list of users. Copy one of the home files to your home file and change the username to your username.

```bash
cd jelle/
cp home.nix ../gillesdemeerleer/
```

Now you can run the following command to apply the configuration:

```bash
home-manager switch --flake .#gillesdemeerleer
```

## Please note

You need to have the wsl extension installed for vscode to use the git system of the Ubuntu otherwise you will have troubles.


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
