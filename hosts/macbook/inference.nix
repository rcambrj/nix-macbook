{ perSystem, ... }: {
  services.ollama = {
    enable = true;
    package = perSystem.nixpkgs-ollama.ollama;
  };

  environment.systemPackages = [
    perSystem.claude-code-nix.default
  ];
}