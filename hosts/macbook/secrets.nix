{ flake, inputs, perSystem, pkgs, ... }:
let
  macbook = import ./macbook.nix;
in  {
  imports = [
    inputs.agenix.darwinModules.default
    inputs.agenix-template.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    perSystem.agenix.agenix
  ];

  age.identityPaths = [ "/Users/${macbook.main-user}/.ssh/id_ed25519" ];

  # all secrets used on this host:
  age.secrets.macbook-linux-vm-ssh-key.file = ../../secrets/macbook-linux-vm-ssh-key.age;
}