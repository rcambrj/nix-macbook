args@{ config, flake, inputs, lib, perSystem, pkgs, ... }:
with flake.lib;
{
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    flake.darwinModules.dock
    ./secrets.nix
    ./macos-preferences.nix
    ./homebrew.nix
    ./dock.nix
    ./docker.nix
    ./nix-conf.nix

    ./builders/linux-builder.nix
    # ./builders/virby.nix
    # ./builders/minimal-intel.nix
    # ./builders/orange.nix

    ./linux-vm.nix
  ];

  system.stateVersion = 5;

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
      (nixos-rebuild-ng.override { withNgSuffix = false; })
  ];
}
