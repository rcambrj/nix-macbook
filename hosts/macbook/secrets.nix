{ flake, inputs, perSystem, pkgs, ... }:
let
  inherit (flake.lib) me;
in  {
  imports = [
    inputs.agenix.darwinModules.default
  ];

  environment.systemPackages = with pkgs; [
    perSystem.agenix.agenix
  ];

  age.identityPaths = [ "/Users/${me.user}/.ssh/id_ed25519" ];

  # all secrets used on this host:
  age.secrets.macbook-linux-vm-ssh-key.file = ../../secrets/macbook-linux-vm-ssh-key.age;
}