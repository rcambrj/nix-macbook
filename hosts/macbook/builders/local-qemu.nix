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

    # comment this block if the vm fails to build: the vm in the binary cache
    # doesn't have any customisations so nix tries to build one from source, but
    # that can't be done without already having an existing vm to build it.
    config = ({ pkgs, ... }:{
      # then uncomment this
      boot.binfmt.emulatedSystems = builderEmulatesSystems;

      # then uncomment this
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