{ ... }: {
  homeConfigurations = import ./home-configurations.nix;
  me = import ./me.nix;
}