{
  description = "Cloudops Team development environment for WSL Ubuntu (git, gh, az cli, zsh, ...)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux"; # WSL is always x86_64-linux or aarch64-linux; adjust if needed
      pkgs = nixpkgs.legacyPackages.${system};

      # One shared config, applied for whichever user runs it.
      mkHome = username: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
        ];
      };
    in
    {
      # Usage: nix run home-manager/master -- switch --flake ".#$(whoami)@wsl"
      homeConfigurations = builtins.listToAttrs (map
        (username: {
          name = "${username}@wsl";
          value = mkHome username;
        })
        [ "gilles" "zoe" "arne" ] # <- add every team member's Linux username here
      );
    };
}
