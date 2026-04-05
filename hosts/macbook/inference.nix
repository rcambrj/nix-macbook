{ lib, pkgs, perSystem, ... }: {
  services.ollama = {
    enable = true;
    package = perSystem.nixpkgs-ollama.ollama;
  };

  environment.systemPackages = let
    opencodeWithSearch = writeScriptBin "opencode" ''
      OPENCODE_ENABLE_EXA=1 ${lib.getExe opencode}
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
  # [...]
  # "qwen3.5:cloud": {
  #   "modalities": {
  #     "input": ["text", "image"],
  #     "output": ["text"]
  #   }
  # }

  # ~/.config/AGENTS.md
  # # Tool Preferences
  # * When fetching URLs or web content, always use the `webfetch`, NEVER use bash commands.
  # * You're encouraged to use the `websearch` tool
}