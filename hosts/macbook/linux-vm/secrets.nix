{ flake, inputs, perSystem, pkgs, ... }:
let
  inherit (flake.lib) me;
in  {
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-template.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    perSystem.agenix.agenix
  ];

  age.identityPaths = [ "/var/lib/agenix-identity/id_ed25519" ];

  # all secrets used on this host:
  age.secrets.foo.file = ../../../secrets/foo.age;
}