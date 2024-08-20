let
  builderEmulatesSystems = [
    "x86_64-linux"
    # "armv7l-linux"
  ];
in
{
  # qemu machine cache: /private/var/lib/darwin-builder/nixos.qcow2
  nix.linux-builder.enable = true;
  nix.linux-builder.systems = builderEmulatesSystems;
  nix.linux-builder.maxJobs = 100;
  nix.linux-builder.config = ({ pkgs, ... }:{
    boot.binfmt.emulatedSystems = builderEmulatesSystems;
  });
}