let
  inherit (flake.lib) me;
in
{
  nix.buildMachines = [{
    hostName = "banana-nomad.local";
    system = "x86_64-linux";
    systems = ["aarch64-linux" "armv7l-linux"];
    sshUser = "nixos";
    sshKey = "/Users/${me.user}/.ssh/id_ed25519";
    maxJobs = 100;
    supportedFeatures = [ "kvm" "big-parallel" ];
  }];
}