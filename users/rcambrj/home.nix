{ config, flake, inputs, perSystem, pkgs, ... }:
let
  inherit (flake.lib) me;
in {
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.username = me.user;
  home.homeDirectory = pkgs.lib.mkForce "/Users/${me.user}";

  home.packages = with pkgs; [
    # don't install dev tooling here. use local devshell flake + direnv instead.
    _1password
    asciinema
    coreutils
    curl
    dotnet-sdk_8
    gnupg
    gnutar # required to support zstd
    htop
    iftop
    nodePackages.localtunnel
    perSystem.mach-composer.default # TODO: remove when devshell can do completions
    perSystem.nixpkgs-unstable.ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512
    nerdfonts
    openssh
    pv
    qemu
    restic
    ripgrep
    tig
    tmate
    tmux
    tree
    unrar
    unzip
    watch
    wget

    # vscode tools
    biome
    go
    nil
    nixd
    terraform
  ];

  fonts.fontconfig.enable = true;

  programs.awscli = {
    enable = true;
    settings = {
      "default" = {
        region = "eu-central-1";
        output = "json";
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    userName = me.name;
    userEmail = me.email;
    ignores = [
      ".envrc"
      ".vscode"
    ];
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core.abbrev = 7;
      core.editor = "vim";
      core.autocrlf = "input";
      core.pager = "less -F -X";
      color.ui = "auto";
      merge.log = true;
      push.default = "current";
      difftool.prompt = false;
      mergetool.prompt = false;
      pull.rebase = true;
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };

  programs.granted = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.ssh = {
    enable = true;
    extraOptionOverrides  = {
      TCPKeepAlive = "yes";
      ServerAliveInterval = "60";
      ConnectTimeout = "2";
    };
    matchBlocks = {
      "router" = {
        hostname =  "192.168.142.1";
        user = "root";
      };
      "blueberry" = {
        hostname =  "blueberry.cambridge.me";
        user = "nixos";
      };
      "cranberry" = {
        hostname =  "cranberry.cambridge.me";
        user = "nixos";
      };
      "minimal-intel" = {
        hostname =  "minimal-intel-nomad.local";
        user = "nixos";
        extraOptions = {
          # this will boot on a variety of shapes
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "minimal-raspi" = {
        hostname =  "minimal-raspi-nomad.local";
        user = "nixos";
        extraOptions = {
          # this will boot on a variety of shapes
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "gooseberry" = {
        hostname =  "192.168.142.23";
        user = "gooseberry";
      };
      "tacx" = {
        hostname =  "tacx.lan";
        user = "pi";
      };
      "tomato" = {
        hostname =  "tomato.cambridge.me";
        user = "root";
      };
      "coconut" = {
        hostname = "coconut.cambridge.me";
        user = "root";
        extraOptions = {
          # currently setting up this machine
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "lime" = {
        hostname = "51.255.83.152";
        user = "root";
        port = 15120;
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git_status = {
        disabled = true;
      };
    };
  };

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
    extensions = with inputs.nix-vscode-extensions.extensions."aarch64-darwin".vscode-marketplace; [
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

  programs.zsh = {
    enable = true;
    autocd = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    # initExtraFirst = "";
    initExtraBeforeCompInit = builtins.readFile ./autocomplete.zsh;
    initExtra = ''
      bindkey -e
      bindkey "^[[3~" delete-char                    # Key Del
      bindkey "^[[5~" beginning-of-buffer-or-history # Key Page Up
      bindkey "^[[6~" end-of-buffer-or-history       # Key Page Down
      bindkey "^[[H" beginning-of-line               # Key Home
      bindkey "^[[F" end-of-line                     # Key End
      bindkey "^[^[[C" forward-word                  # Key Alt + Right
      bindkey "^[^[[D" backward-word                 # Key Alt + Left

      set-window-title() {
        window_title="\e]0;''${''${PWD/#"$HOME"/~}/projects/p}\a"
        echo -ne "$window_title"
      }

      set-window-title
      add-zsh-hook precmd set-window-title

      # completion
      # TODO: why doesn't /Users/rcambrj/.nix-profile/share/zsh/site-functions/_mach-composer work?
      eval "$(${pkgs.lib.getExe perSystem.mach-composer.default} completion zsh)"
    '';
    history = {
      ignoreAllDups = true;
    };
    plugins = [];
    shellAliases = {
      dwu = "darwin-rebuild switch --flake ~/projects/nix/macbook/#macbook";
      dwa = "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u";
      ngc = "nix-collect-garbage -d";

      flun = "nix flake update nixpkgs";
      fluh = "nix flake update home-manager";
      flub = "nix flake update nix-homebrew homebrew-bundle homebrew-core homebrew-cask";
      fluo = "nix flake update nix-vscode-extensions mach-composer";
      flua = "flun && fluh && flub && fluo";

      g    = "git";
      # git reset
      grs  = "git reset";
      grss = "git reset --soft";
      grsh = "git reset --hard";
      grso = "git reset --hard origin/`git rev-parse --abbrev-ref HEAD`";
      grsm = "git reset --hard origin/main";
      # git rebase
      grb  = "git rebase";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      grbi = "git rebase --interactive";
      grbs = "git rebase --skip";
      grbo = "git rebase origin/`git rev-parse --abbrev-ref HEAD`";
      grbm = "git rebase origin/main";
      # git cherry-pick
      gcp  = "git cherry-pick";
      gcpa = "git cherry-pick --abort";
      gcpc = "git cherry-pick --continue";
      # git other
      gcl  = "git clone";
      gst  = "git status";
      gsp  = "git stash push";
      gsa  = "git stash apply";
      gf   = "git fetch --all --prune --jobs=10";
      gpr  = "git pull --rebase";
      gd   = "git diff";
      gds  = "git diff --staged";
      ga   = "git add";
      gco  = "git checkout";
      gci  = "git commit";
      gcia = "git commit --amend";
      gp   = "git push";
      gpf  = "git push --force-with-lease";
      gh   = "git rev-parse --short HEAD";

      l = "ls -la";
      vim = "nvim";
      ip = "curl ifconfig.co";
      tf = "terraform";

      etch = "sudo dd status=progress bs=4M conv=fsync"; # if=foo.img of=/dev/disk69 && sync
    };
  };
}
