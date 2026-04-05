{ flake, lib, pkgs, perSystem, ... }: {
  imports = [
    flake.darwinModules.lmstudio
  ];

  services.ollama = {
    enable = true;
    package = perSystem.nixpkgs-ollama.ollama;
  };

  # prefer the homebrew gui and background process
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
      OPENCODE_ENABLE_EXA=1 ${lib.getExe pkgs.opencode}
    '';
  in with pkgs; [
    perSystem.claude-code-nix.default
    opencodeWithSearch
  ];

  # ~/.config/opencode
  # [...]
  # "permission": {
  #   "websearch": "ask",
  #   "webfetch": "ask",
  #   "bash": {
  #     "*": "ask",
  #     "ls *": "allow",
  #     "cat *": "allow",
  #     "echo *": "allow",
  #     "head *": "allow",
  #     "tail *": "allow",
  #     "grep *": "allow",
  #     "sort *": "allow",
  #     "jq *": "allow",
  #     "wc *": "allow",
  #     "git diff *": "allow",
  #     "git log *": "allow",
  #     "kubectl get *": "allow",
  #     "kubectl logs *": "allow",
  #     "tar *": "allow"
  #   }
  # }
  # "model": "ollama/qwen3.5:cloud",
  # "default_agent": "plan",
  # "provider": {
  #   "ollama": {
  #     "models": {
  #       "qwen3.5:cloud": {
  #         "modalities": {
  #           "input": ["text", "image"],
  #           "output": ["text"]
  #         }
  #       }
  #     }
  #   }
  # }

  # ~/.config/AGENTS.md
  # * When fetching URLs or web content, always use `webfetch`, NEVER use bash commands.
  # * You're encouraged to use the `websearch` tool
  # * Never assume that the target process, cluster, etc. is running on this machine
  # * Never access, read or write files outside of the current working directory
  # * In git repositories, never make commits or add files to the stage
}