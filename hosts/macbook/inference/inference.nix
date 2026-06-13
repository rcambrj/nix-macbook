{ config, flake, inputs, lib, pkgs, perSystem, ... }:
with flake.lib;
let
  llamaCppModel = "devstral-small-2507-ud-q4_k_xl-64k";
  llamaCppPort = 8080;
in
{
  imports = [
    inputs.agent-sandbox.nixosModules.opencode-sandbox
  ];

  homebrew.casks = ["lm-studio"];

  environment.systemPackages = let
    opencodeWithSearch = pkgs.writeScriptBin "opencode" ''
      OPENCODE_ENABLE_EXA=1 OPENCODE_EXPERIMENTAL_WEBSOCKETS=1 ${lib.getExe perSystem.numtide-llm-agents.opencode} $@
    '';
  in with pkgs; [
    llama-cpp
    perSystem.numtide-llm-agents.claude-code
    perSystem.numtide-llm-agents.semble
    opencodeWithSearch
  ];

  launchd.user.agents.llama-cpp = let
    llamaCppArgs = [
      # Model selection
      "-hf" "unsloth/Devstral-Small-2507-GGUF"
      "--hf-file" "Devstral-Small-2507-UD-Q4_K_XL.gguf"
      "--alias" llamaCppModel

      # Memory and context
      "--ctx-size" "65536"
      "--cache-type-k" "q4_0"
      "--cache-type-v" "q4_0"
      "--gpu-layers" "all"

      # Sampling
      "--temp" "0.15"
      "--min-p" "0.01"

      # Idle and prompt cache behavior
      "--cache-ram" "0"
      "--sleep-idle-seconds" "300"

      # Chat/template support
      "--jinja"

      # API
      "--host" "127.0.0.1"
      "--port" (toString llamaCppPort)
    ];
  in {
    command = lib.escapeShellArgs ([ "${pkgs.llama-cpp}/bin/llama-server" ] ++ llamaCppArgs);
    serviceConfig = {
      UserName = macbook.main-user;
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Users/${macbook.main-user}/Library/Logs/llama-cpp.log";
      StandardErrorPath = "/Users/${macbook.main-user}/Library/Logs/llama-cpp.err";
    };
  };

  programs.opencode-sandbox = let
    lmStudioPort = 1234;
  in {
    enable = true;
    showBootLogs = true;
    envFile = "/Users/${macbook.main-user}/.config/opencode-sandbox/env";
    dataDir = "/Users/${macbook.main-user}/.config/opencode-sandbox/data";
    cacheDir = "/Users/${macbook.main-user}/.config/opencode-sandbox/cache";
    exposeHostPorts = [ lmStudioPort llamaCppPort ];
    configDir = let
      opencode-json = pkgs.writeText "opencode.json" (builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        autoupdate = false;
        permission = {
          # sandboxed as root, go wild
          "*" = "allow";
          "question" = "deny";
        };
        default_agent = "plan";
        agent = {
          # plan.model = "openai/gpt-5.4"; build.model = "openai/gpt-5.4-mini";
          plan.model = "openai/gpt-5.3-codex"; build.model = "openai/gpt-5.3-codex";
          # plan.model = "openai/gpt-5.3-codex"; build.model = "openai/gpt-5.4-mini";
          # plan.model = "opencode-go/glm-5.1"; build.model = "opencode-go/minimax-m2.7";
          # plan.model = "opencode-go/glm-5.1"; build.model = "opencode-go/qwen3.5-plus";
        };
        instructions = [
          "https://raw.githubusercontent.com/rcambrj/opencode/refs/heads/main/AGENTS.md"
        ];
        provider.lm-studio = {
          name = "lm-studio";
          npm = "@ai-sdk/openai-compatible";
          options.baseURL = "http://127.0.0.1:${toString lmStudioPort}/v1";
          models."qwen3.5-4b-mlx".name = "qwen3.5-4b-mlx";
        };
        provider.llama-cpp = {
          name = "llama-cpp";
          npm = "@ai-sdk/openai-compatible";
          options.baseURL = "http://127.0.0.1:${toString llamaCppPort}/v1";
          models."${llamaCppModel}" = {
            name = llamaCppModel;
            tool_call = true;
            limit = {
              context = 65536;
              output = 4096;
            };
          };
        };
      });
    in pkgs.runCommand "opencode-sandbox-config" {} ''
      mkdir -p "$out"
      cp ${opencode-json} "$out/opencode.json"
    '';

    extraModules = [{
      microvm.vcpu = lib.mkForce 8;
      microvm.mem = lib.mkForce 16384;
    }];
  };
}
