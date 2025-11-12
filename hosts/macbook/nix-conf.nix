{ inputs, pkgs, ... }: {
  imports = [
    inputs.self.nixosModules.common
  ];

  nix.enable = true; # enable management of nix & nix.conf

  nix.channel.enable = false;
  nix.package = pkgs.nixVersions.latest;
  nix.distributedBuilds = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = false; # https://github.com/NixOS/nix/issues/7273
  nix.settings.trusted-users = [
    "@wheel"
    "@admin"
  ];
  nix.settings.use-case-hack = false;
}
