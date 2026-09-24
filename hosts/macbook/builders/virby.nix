{ inputs, ... }: {
  imports = [
    inputs.virby.darwinModules.default
  ];

  # can't connect to the vm, probably:
  # https://github.com/quinneden/virby-nix-darwin/issues/9

  services.virby = {
    enable = true;
    rosetta = true;
    speedFactor = 1000;
    # store hash mismatches occur when virby is powered off (maybe), so keep it on
    onDemand.enable = false;
  };
}
