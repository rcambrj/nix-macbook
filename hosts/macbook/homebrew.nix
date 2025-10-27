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
      "android-studio"
      "arq"
      "balenaetcher"
      "battery" # https://github.com/mhaeuser/Battery-Toolkit looks better but no cask
      "choosy" # browser selector
      "db-browser-for-sqlite"
      "discord"
      "element"
      "firefox"
      # "freecad" # cask is old 0.21, download 1.0 manually
      "ghidra" "temurin" "imhex"
      "gog-galaxy"
      "google-chrome"
      "google-drive"
      "graphiql"
      "hot" # menubar temperature
      "iterm2"
      # "lingon-x" # launchd plists. damnit sha doesnt match
      "lunar"
      "macfuse"
      "macs-fan-control"
      "messenger"
      "music-decoy" # prevents play/pause from opening Apple Music
      "obs"
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
      "transmission"
      # "topnotch" # black menubar hides the notch. not needed with black wallpaper
      "utm"
      "vlc"
      # "vmware-fusion"
      # "vuescan" # cannot install 9.8.27
      # "ytmdesktop-youtube-music" # use Chrome PWA due to https://github.com/ytmdesktop/ytmdesktop/issues/1308
      "winbox"
    ];
    masApps = {
      # for apps which incessantly update themselves
      telegram = 747648890;
      whatsapp = 310633997;
      slack = 803453959;
      dns-sd-browser = 1381004916;
      ibar-pro = 6737150304;
      # fluffy-chat = 1551469600; # no such ID?
      harvest = 506189836;
    };
  };
}