{
  nix.buildMachines = [{
    hostName = "minimal-intel-nomad.local";
    system = "x86_64-linux";
    systems = ["aarch64-linux" "armv7l-linux"];
    sshUser = "nixos";
    maxJobs = 100;
    supportedFeatures = [ "kvm" "big-parallel" ];
  }];
}