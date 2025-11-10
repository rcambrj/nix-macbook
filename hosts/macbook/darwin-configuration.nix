args@{ config, flake, inputs, lib, perSystem, pkgs, ... }:
with flake.lib;
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    flake.darwinModules.dock
    ./secrets.nix
    flake.nixosModules.common
    ./macos-preferences.nix
    ./homebrew.nix
    ./dock.nix
    ./linux-vm.nix
    ./docker.nix

    ./builders/local-qemu.nix
    # ./builders/minimal-intel.nix
    # ./builders/orange.nix
  ];

  system.stateVersion = 5;
  nix.channel.enable = false;

  system.primaryUser = macbook.main-user;
  home-manager.users.${macbook.main-user}.imports = [ ./home-manager ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs perSystem;
    hostname = config.networking.hostName;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nixVersions.latest;
  nix.distributedBuilds = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = false; # https://github.com/NixOS/nix/issues/7273
  nix.settings.trusted-users = [
    "root"
    "@wheel"
    "@admin"
  ];
  nix.settings.use-case-hack = false;
  security.pam.services.sudo_local.touchIdAuth = true;
  programs.zsh.enable = true;
  users.users.${macbook.main-user}.shell = pkgs.zsh;
  networking = {
    computerName = "rcambrj";
    hostName = "rcambrj";
  };

  # do zsh autocompletion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  environment.systemPackages = with pkgs; [
      iproute2mac
  ];
}
