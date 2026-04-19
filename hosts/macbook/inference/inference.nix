{ config, flake, inputs, lib, pkgs, perSystem, ... }: {
  imports = [
    flake.darwinModules.lmstudio
    inputs.opencode-sandbox.nixosModules.opencode-sandbox
  ];

  age.secrets.opencode-go-api-key.file = ../../../secrets/opencode-go-api-key.age;
  age-template.files.opencode-sandbox-env = {
    vars = {
      opencode_go_api_key = config.age.secrets.opencode-go-api-key.path;
    };
    content = ''
      OPENCODE_ENABLE_EXA=1
      OPENCODE_API_KEY=$opencode_go_api_key
      OPENAI_API_KEY=
      ZHIPU_API_KEY=
    '';
    # owner = "opencode";
    # group = "opencode";
  };

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

    envFile = config.age-template.files.opencode-sandbox-env.path;

    configDir = let
      opencode-json = pkgs.writeText "opencode.json" (builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        autoupdate = false;
        permission = {
          # sandboxed as root, go wild
          "*" = "allow";
        };
        default_agent = "plan";

        instructions = [
          "https://raw.githubusercontent.com/rcambrj/opencode/refs/heads/main/AGENTS.md"
        ];

        # provider/model examples
        provider = {
          opencode-go.models."qwen3.5-plus" = {};
          openai.models."gpt-5.4" = {};
          zai-coding-plan.model."glm-5.1" = {};
          ollama = {
            # Ollama is expected to run outside the sandbox VM.
            # Set `baseURL` to an endpoint reachable from inside the guest.
            # When Ollama is exposed on the VM's host, the QEMU default gateway is `10.0.2.2`:
            options.baseURL = "http://10.0.2.2:11434/v1";
            models."llama3.1" = {};
          };
        };

      });
    in pkgs.runCommand "opencode-sandbox-config" {} ''
      mkdir -p "$out"
      cp ${opencode-json} "$out/opencode.json"
    '';

    # optional
    dataDir = /persist/opencode/data;
    cacheDir = /persist/opencode/cache;
    showBootLogs = false;
    extraModules = [
      {
        # for `opencode-sandbox -- serve --hostname 0.0.0.0 --port 4096`
        networking.firewall.allowedTCPPorts = [ 4096 ];
      }
    ];
  };
}