{ pkgs, inputs, system, ... }:
let name  = "Robert Cambridge";
    user  = "rcambrj";
    email = "robert@cambridge.me";
    hostname = "rcambrj";
in {
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.username = user;
  home.homeDirectory = "/Users/${user}";

  home.packages = with pkgs; [
    _1password
    curl
    htop
    iftop
    ncdu
    openssh
    ripgrep
    tmate
    tmux
    tree
    unrar
    unzip
    wget
    tig
    nerdfonts
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
    userName = name;
    userEmail = email;
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
      #commit.gpgsign = true;
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
    extensions = with inputs.nix-vscode-extensions.extensions.${system}; [
      vscode-marketplace.bbenoist.nix
    ];
  };

  programs.zsh = {
    # TODO: change the iterm tab title with printf "\e]1;title\a"
    enable = true;
    autocd = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    # initExtraFirst = "";
    initExtraBeforeCompInit = builtins.readFile ./autocomplete.zsh;
    # initExtra = "";
    history = {
      ignoreAllDups = true;
    };
    plugins = [];
    shellAliases = {
      dwu = "darwin-rebuild switch --flake ~/projects/nix/macbook/#rcambrj";
      hmu = "home-manager switch --flake ~/projects/nix/macbook/#rcambrj";
      dwa = "/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u";

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
      gpf  = "git push --force-with-lease --force-if-includes";
      gh   = "git rev-parse --short HEAD";

      l = "ls -la";
      ip = "curl ifconfig.co";
    };
  };
}
