{ config, flake, inputs, lib, pkgs, perSystem, ... }:
with flake.lib;
{
  imports = [
    flake.darwinModules.lmstudio
    inputs.opencode-sandbox.nixosModules.opencode-sandbox
  ];

  age.secrets.opencode-go-api-key.file = ../../../secrets/opencode-go-api-key.age;

  services.ollama = {
    enable = true;
    package = pkgs.ollama;
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
      OPENCODE_ENABLE_EXA=1 ${lib.getExe perSystem.opencode.opencode} $@
    '';
  in with pkgs; [
    perSystem.claude-code-nix.default
    opencodeWithSearch
  ];

  programs.opencode-sandbox = {
    enable = true;

    envFile = "/Users/${macbook.main-user}/.config/opencode-sandbox/env";
    dataDir = "/Users/${macbook.main-user}/.config/opencode-sandbox/data";
    cacheDir = "/Users/${macbook.main-user}/.config/opencode-sandbox/cache";

    configDir = let
      opencode-json = pkgs.writeText "opencode.json" (builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        autoupdate = false;
        permission = {
          # sandboxed as root, go wild
          "*" = "allow";
        };
        default_agent = "plan";
        agent = {
          plan = {
            mode =  "primary";
            model =  "openai/gpt-5.4";
          };
          build =  {
            mode =  "primary";
            model =  "opencode-go/qwen3.5-plus";
          };
        };
        instructions = [
          "https://raw.githubusercontent.com/rcambrj/opencode/refs/heads/main/AGENTS.md"
        ];
      });
    in pkgs.runCommand "opencode-sandbox-config" {} ''
      mkdir -p "$out"
      cp ${opencode-json} "$out/opencode.json"
    '';

    extraModules = [{
      nix.settings.experimental-features = [ "nix-command" "flakes" ]; # TODO: upstream
      programs.git = {
        enable = true;
        config.safe.directory = [ "*" ]; # TODO: upstream
      };
      virtualisation.cores = lib.mkForce 8;
      virtualisation.memorySize = lib.mkForce 16384;
    }];
  };
}