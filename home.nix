{ config, pkgs, ... }:

{
  home.stateVersion = "24.05";

  #############################################
  ## Packages available on PATH
  #############################################
  home.packages = with pkgs; [
    azure-cli
    terraform
    kubectl
    jq
    ripgrep
    fzf
    bat
    eza
    direnv
  ];

  #############################################
  ## Git
  #############################################
  programs.git = {
    enable = true;
    userName = "CHANGE_ME"; # override per-user via home.nix local overlay, see README
    userEmail = "change_me@yourcompany.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "vim";
    };
  };

  #############################################
  ## GitHub CLI
  #############################################
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "vim";
    };
  };

  #############################################
  ## Zsh + prompt
  #############################################
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "azure" "fzf" "direnv" ];
      theme = "robbyrussell";
    };

    shellAliases = {
  ll = "eza -la";
  cat = "bat";

  # Terraform
  tf = "terraform";
  tfa = "terraform apply";
  tfp = "terraform plan";
  tfi = "terraform init";
  tfd = "terraform destroy";
  tfv = "terraform validate";
  tffm = "terraform fmt -recursive";

  # Azure CLI
  azl = "az login";
  azs = "az account set --subscription";
  azw = "az account show --query name -o tsv"; # "welke sub sta ik op"

  # git / gh
  gs = "git status";
  gp = "git pull";
  gco = "git checkout";
  prc = "gh pr create";
  prv = "gh pr view --web";
};

    initExtra = ''
      # Azure CLI + gh completions are wired in automatically by their home-manager modules.
      eval "$(direnv hook zsh)"
    '';
  };

  programs.starship.enable = true; # optional: nicer prompt, remove if you prefer oh-my-zsh's theme

  # Make zsh the login shell for WSL users.
  # (home-manager can't chsh directly; bootstrap.sh / README covers the one-time `chsh -s $(which zsh)`)
}
