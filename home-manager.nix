{ pkgs, pkgs-24-05, pkgs-unstable, nixVscodeExtensions, ... }:
let
  me = import ./me.nix;
in {
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.username = me.user;
  home.homeDirectory = "/Users/${me.user}";

  home.packages = with pkgs; [
    # don't install dev tooling here. use local devshell flake + direnv instead.
    _1password
    curl
    go # global instance for vscode
    htop
    iftop
    pkgs-24-05.ncdu # TODO: https://github.com/NixOS/nixpkgs/issues/290512
    nerdfonts
    nil # global instance for vscode
    openssh
    ripgrep
    terraform # global instance for vscode
    tig
    tmate
    tmux
    tree
    unrar
    unzip
    wget
    mach-composer # TODO: remove when devshell can do completions
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
    };
    matchBlocks = {
      "router" = {
        hostname =  "192.168.142.1";
        user = "root";
      };
      "strawberry" = {
        hostname =  "192.168.142.20";
        user = "strawberry";
      };
      "blueberry" = {
        hostname =  "blueberry";
        user = "nixos";
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };
      "blueberry-vm" = {
        hostname =  "localhost";
        user = "nixos";
        port = 2224;
        extraOptions = {
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
        hostname =  "172.245.118.14";
        user = "root";
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
      "telemetry.enableCrashReporter" = false;
      "telemetry.enableTelemetry" = false;
      "redhat.telemetry.enabled" = false;
      "liveshare.authenticationProvider" = "GitHub";
      "liveshare.presence" = true;
      "gitlens.codeLens.enabled" = false;
      "gitlens.codeLens.recentChange.enabled" = false;
      # "go.toolsManagement.autoUpdate" = false; # maybe not necessary with enableExtensionUpdateCheck=false?
      "search.useIgnoreFiles" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "workbench.colorTheme" = "Dark+ (contrast)";
      "[javascript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescriptreact]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[json]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[graphql]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
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
    extensions = with nixVscodeExtensions.vscode-marketplace; [
      bbenoist.nix
      # eamodio.gitlens
      esbenp.prettier-vscode
      github.vscode-github-actions
      golang.go
      hashicorp.terraform
      jnoortheen.nix-ide
      orsenkucher.vscode-graphql
      signageos.signageos-vscode-sops
      tamasfe.even-better-toml
      github.vscode-pull-request-github
      k3a.theme-dark-plus-contrast
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
      eval "$(${pkgs.lib.getExe pkgs.mach-composer} completion zsh)"
    '';
    history = {
      ignoreAllDups = true;
    };
    plugins = [];
    shellAliases = {
      dwu = "darwin-rebuild switch --flake ~/projects/nix/macbook/#rcambrj";
      hmu = "home-manager switch --flake ~/projects/nix/macbook/#rcambrj";
      dwa = "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u";

      flun = "nix flake lock --update-input nixpkgs";
      fluh = "nix flake lock --update-input home-manager";
      flub = "nix flake lock --update-input nix-homebrew --update-input homebrew-bundle --update-input homebrew-core --update-input homebrew-cask";
      fluo = "nix flake lock --update-input nix-vscode-extensions --update-input mach-composer";
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
    };
  };
}
