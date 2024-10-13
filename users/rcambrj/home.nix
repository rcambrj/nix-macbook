{ config, flake, inputs, perSystem, pkgs, ... }:
let
  me = import ./me.nix;
in {
  imports = [
    ./ssh.nix
    ./shell.nix
    ./vscode.nix
    ./git.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
  home.username = me.user;
  home.homeDirectory = pkgs.lib.mkForce (if pkgs.stdenv.isDarwin then "/Users/${me.user}" else "/home/${me.user}");

  home.packages = with pkgs; [
    # don't install dev tooling here. use local devshell flake + direnv instead.
    _1password
    asciinema
    coreutils
    curl
    dotnet-sdk_8
    gnupg
    htop
    iftop
    nodePackages.localtunnel
    perSystem.nixpkgs-unstable.ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512
    nerdfonts
    openssh
    qemu
    restic
    ripgrep
    tig
    tmate
    tmux
    tree
    unrar
    unzip
    watch
    wget
  ];

  fonts.fontconfig.enable = true;

  programs.awscli = {
    enable = true;
    settings = {
      "default" = {
        region = "eu-central-1";
        output = "json";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.granted = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
