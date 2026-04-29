{ pkgs, ... }: {
  nix.linux-builder = {
    # use linux-builder to build virby
    enable = false;
    speedFactor = 1;

    ephemeral = true;
    systems = [ "aarch64-linux" ];
    maxJobs = 100;
  };
}
