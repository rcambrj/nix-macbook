{ flake, pkgs, ... }:
with flake.lib;
{
  environment.systemPackages = with pkgs; [
    dockutil
  ];

  dock = {
    enable = true;
    entries = [
      { path = "/Applications/Firefox.app"; }
      { path = "/Applications/Google Chrome.app"; }
      { path = "/Applications/1Password.app"; }
      { path = "/Applications/iTerm.app"; }
      { path = "/Users/${macbook.main-user}/Applications/Home Manager Apps/Visual Studio Code.app"; }
      { path = "/Applications/Spotify.app"; }
      { path = "/Applications/Slack.app"; }
      { path = "/Applications/Telegram.app"; }
      { path = "/Applications/WhatsApp.app"; }
      { path = "/Applications/Signal.app"; }
      { path = "/Applications/Messenger.app"; }
    ];
  };
}
