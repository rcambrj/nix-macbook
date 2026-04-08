{ flake, inputs, lib, pkgs, perSystem, ... }: {
  imports = [
    flake.darwinModules.lmstudio
  ];

  services.ollama = {
    enable = true;
    package = perSystem.nixpkgs-ollama.ollama;
  };

  nix-homebrew.taps = {
      "arthur-ficial/homebrew-tap" = inputs.arthur-ficial;
  };
  # prefer the homebrew gui and background process
  homebrew.brews = ["arthur-ficial/tap/apfel"];
  homebrew.casks = ["lm-studio"];
  # services.lmstudio = {
  #   enable = true;
  #   package = perSystem.self.lmstudio;
  #   port = 1234;
  #   environmentVariables = {
  #     MTL_HUD_ENABLED = "1";
  #     METAL_DEVICE_WRAPPER_TYPE = "1";
  #   };
  # };

  environment.systemPackages = let
    opencodeWithSearch = pkgs.writeScriptBin "opencode" ''
      OPENCODE_ENABLE_EXA=1 ${lib.getExe pkgs.opencode} $@
    '';
  in with pkgs; [
    perSystem.claude-code-nix.default
    opencodeWithSearch
  ];
}