{ config, flake, inputs, lib, pkgs, perSystem, ... }:
with flake.lib;
{
  imports = [
    inputs.agent-sandbox.nixosModules.opencode-sandbox
  ];

  homebrew.casks = ["lm-studio"];

  environment.systemPackages = let
    opencodeWithSearch = pkgs.writeScriptBin "opencode" ''
      OPENCODE_ENABLE_EXA=1 ${lib.getExe perSystem.numtide-llm-agents.opencode} $@
    '';
  in with pkgs; [
    llama-cpp
    perSystem.numtide-llm-agents.claude-code
    opencodeWithSearch
  ];

  launchd.user.agents.llama-cpp-gemma = let
    llamaCppPort = 8080;
  in {
    command = "${pkgs.llama-cpp}/bin/llama-server -hf ggml-org/gemma-4-E4B-it-GGUF --alias gemma-4-e4b-it --host 127.0.0.1 --port ${toString llamaCppPort}";
    serviceConfig = {
      UserName = macbook.main-user;
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/Users/${macbook.main-user}/Library/Logs/llama-cpp-gemma.log";
      StandardErrorPath = "/Users/${macbook.main-user}/Library/Logs/llama-cpp-gemma.err";
    };
  };

  programs.opencode-sandbox = let
    lmStudioPort = 1234;
    llamaCppPort = 8080;
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
          models."gemma-4-e4b-it".name = "gemma-4-e4b-it";
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
