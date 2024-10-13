{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    # for language servers
    biome
    dotnet-sdk_8
    go
    nil
    nixd
    terraform
  ];

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    userSettings = {
      "editor.tabSize" = 4;
      "editor.insertSpaces" = false;
      "editor.detectIndentation" = true;
      "liveshare.focusBehavior" = "prompt";
      "liveshare.guestApprovalRequired" = true;
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "workbench.editor.tabSizing" = "shrink";
      "workbench.editor.tabActionCloseVisibility" = false;
      "editor.minimap.enabled" = false;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "editor.parameterHints.enabled" = false;
      "editor.suggestSelection" = "recentlyUsedByPrefix";
      "editor.rulers" = [ 80 100 120 ];
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.acceptSuggestionOnCommitCharacter" = false;
      "editor.fontSize" = 13;
      "telemetry.telemetryLevel" = "off";
      "telemetry.enableCrashReporter" = false;
      "telemetry.enableTelemetry" = false;
      "redhat.telemetry.enabled" = false;
      "liveshare.authenticationProvider" = "GitHub";
      "liveshare.presence" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.codeLens.recentChange.enabled" = false;
      "search.useIgnoreFiles" = false;
      "files.watcherExclude" = {
        "**/.git/objects/**" = true;
        "**/node_modules/**" = true;
      };

      # jnoortheen.nix-ide
      "nix.enableLanguageServer" = false; # keeps crashing
      "nix.serverPath" = "nixd"; # or nil

      "workbench.colorTheme" = "Dark+ (contrast)";
      "[javascript]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      "[json]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      "[graphql]" = {
        "editor.defaultFormatter" = "biomejs.biome";
      };
      "[terraform]" = {
        "editor.defaultFormatter" = "hashicorp.terraform";
      };
      "[terraform-vars]" = {
        "editor.defaultFormatter" = "hashicorp.terraform";
      };
      "[go]" = {
        "editor.defaultFormatter" = "golang.go";
        "formatting.gofumpt" = true;
      };
    };
    mutableExtensionsDir = false;
    # TODO: don't hardcode system
    extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace; [
      # esbenp.prettier-vscode # is biome better? let's see
      biomejs.biome

      github.vscode-github-actions
      github.vscode-pull-request-github
      golang.go
      hashicorp.terraform
      jnoortheen.nix-ide
      # bbenoist.nix
      k3a.theme-dark-plus-contrast
      ms-vscode.makefile-tools
      orsenkucher.vscode-graphql
      tamasfe.even-better-toml

      # dotnet
      ms-dotnettools.vscode-dotnet-runtime
      ms-dotnettools.csharp
      ms-dotnettools.csdevkit
    ];
  };
}