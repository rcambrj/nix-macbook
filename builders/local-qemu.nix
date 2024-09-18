let
  builderEmulatesSystems = [
    "x86_64-linux"
    # "armv7l-linux"
  ];
in
{
  # qemu machine cache: /private/var/lib/darwin-builder/nixos.qcow2
  nix.linux-builder = {
    enable = true;
    ephemeral = true;
    systems = [ "aarch64-linux" ] ++ builderEmulatesSystems;
    maxJobs = 100;
    config = ({ pkgs, ... }:{
      boot.binfmt.emulatedSystems = builderEmulatesSystems;
      virtualisation = {
        darwin-builder = {
          diskSize = 100 * 1024;
          memorySize = 4 * 1024;
        };
        cores = 6;
      };
    });
  };
}