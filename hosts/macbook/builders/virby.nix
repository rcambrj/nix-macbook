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
    onDemand = {
      enable = true;
      ttl = 1; # Idle timeout in minutes
    };
  };
}