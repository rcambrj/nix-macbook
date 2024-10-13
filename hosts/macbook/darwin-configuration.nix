args@{ config, flake, inputs, lib, perSystem, pkgs, ... }:
let
  macbook = import ./macbook.nix;
in {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager
    flake.darwinModules.dock
    ./secrets.nix
    # ./builders/banana.nix
    ./builders/local-qemu.nix
    ./macos-preferences.nix
    ./homebrew.nix
    ./dock.nix
    ./linux-vm
    ./docker.nix
  ];

  system.stateVersion = 5;
  nix.channel.enable = false;

  home-manager.users.${macbook.main-user}.imports = [ ./home-manager ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs perSystem; };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nixVersions.nix_2_21;
  nix.distributedBuilds = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = false; # https://github.com/NixOS/nix/issues/7273
  nix.settings.trusted-users = [
    "root"
    "@wheel"
    "@admin"
  ];
  nix.settings.substituters = lib.mkForce config.nix.settings.trusted-substituters;
  nix.settings.trusted-substituters = [
    "https://cache.nixos.org/"
    "https://nix-community.cachix.org"
    "https://cache.garnix.io"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  ];
  services.nix-daemon.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  programs.zsh.enable = true;
  users.users.${macbook.main-user}.shell = pkgs.zsh;
  networking = {
    computerName = "rcambrj";
    hostName = "rcambrj";
  };

  # do zsh autocompletion for system packages
  environment.pathsToLink = [ "/share/zsh" ];


  # TODO: figure out how to have rclone cache the remote disk locally. too slow to fetch each item on demand.
  # launchd.user.agents.gdrive = {
  #   serviceConfig = {
  #     ProgramArguments = [
  #       "/bin/sh"
  #       "-c"
  #       "/bin/wait4path \"${pkgs.lib.getExe pkgs.rclone}\" &amp;&amp; exec \"${pkgs.lib.getExe pkgs.rclone}\" mount gdrive:/ /Users/${macbook.main-user}/gdrive"
  #     ];
  #     UserName = macbook.main-user;
  #     RunAtLoad = true;
  #     KeepAlive = {
  #       NetworkState = true;
  #     };
  #     StandardOutPath = /Users/${macbook.main-user}/gdrive.log;
  #     StandardErrorPath = /Users/${macbook.main-user}/gdrive.err;
  #   };
  # };
}
