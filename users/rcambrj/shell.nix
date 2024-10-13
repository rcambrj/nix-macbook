{ pkgs, perSystem, ... }: {
  home.packages = with pkgs; [
    perSystem.mach-composer.default # TODO: remove when devshell can do completions
  ];

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
      ngc = "sudo nix-collect-garbage -d";

      flun = "nix flake update nixpkgs";
      fluh = "nix flake update home-manager";
      flub = "nix flake update nix-homebrew homebrew-bundle homebrew-core homebrew-cask";
      fluo = "nix flake update nix-vscode-extensions mach-composer";
      flua = "flun && fluh && flub && fluo";

      l = "ls -lah";
      vim = "nvim";
      ip = "curl ifconfig.co";
      tf = "terraform";

      etch = "sudo dd status=progress bs=4M conv=fsync"; # if=foo.img of=/dev/disk69 && sync
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
}