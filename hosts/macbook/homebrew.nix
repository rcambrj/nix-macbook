{ config, flake, inputs, ... }:
with flake.lib;
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = macbook.main-user;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
  };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
      autoUpdate = true;
    };
    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [];
    casks = [
      "1password"
      "arq"
      "balenaetcher"
      "battery" # https://github.com/mhaeuser/Battery-Toolkit looks better but no cask
      "choosy" # browser selector
      "db-browser-for-sqlite"
      "discord"
      "element"
      "firefox"
      # "freecad" # cask is old 0.21, download 1.0 manually
      "ghidra" "temurin"
      "gog-galaxy"
      "google-chrome"
      "google-drive"
      "hot" # menubar temperature
      "graphiql"
      "imhex"
      "iterm2"
      # "lingon-x" # launchd plists. damnit sha doesnt match
      "lunar"
      "macfuse"
      "macs-fan-control"
      "messenger"
      "music-decoy" # prevents play/pause from opening Apple Music
      "orcaslicer"
      "paragon-extfs"
      "postman-agent"
      "private-internet-access"
      "raspberry-pi-imager"
      "rectangle"
      "rustdesk"
      "signal"
      "spotify"
      "steam"
      "tailscale"
      "transmission"
      # "topnotch" # black menubar hides the notch. not needed with black wallpaper
      "utm"
      "vmware-fusion"
      "winbox"
      "zerotier-one"
    ];
    masApps = {
      # for apps which incessantly update themselves
      telegram = 747648890;
      whatsapp = 310633997;
      slack = 803453959;
      dns-sd-browser = 1381004916;
      ibar-pro = 6737150304;
      quick-camera = 598853070;
    };
  };
}