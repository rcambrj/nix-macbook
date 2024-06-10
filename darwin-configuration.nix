{ pkgs, inputs, system, ... }:
let name  = "Robert Cambridge";
    user  = "rcambrj";
    email = "robert@cambridge.me";
    hostname = "rcambrj";
in {
  imports = [
    ./dock
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.trusted-substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  security.pam.enableSudoTouchIdAuth = true;
  programs.zsh.enable = true;
  users.users.${user}.shell = pkgs.zsh;
  networking = {
    computerName = hostname;
    hostName = hostname;
  };

  environment.systemPackages = with pkgs; [
    dockutil
    rclone
  ];
  # do zsh autocompletion for system packages
  environment.pathsToLink = [ "/share/zsh" ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = false;
    };
    taps = [];
    brews = [];
    casks = [
      "1password"
      "battery" # https://github.com/mhaeuser/Battery-Toolkit looks better but no cask
      "choosy" # browser selector
      "discord"
      "firefox"
      "google-chrome"
      "hot" # menubar temperature
      "iterm2"
      "lingon-x" # launchd plists
      "lunar"
      "macfuse"
      "macs-fan-control"
      "microsoft-outlook"
      "microsoft-teams"
      "private-internet-access"
      "rectangle"
      "spotify"
    ];
    masApps = {
      # for apps which incessantly update themselves
      telegram = 747648890;
      whatsapp = 310633997;
      slack = 803453959;
    };
  };

  local = {
    dock.enable = true;
    dock.entries = [
      { path = "/Applications/Firefox.app/"; }
      { path = "/Applications/Google Chrome.app/"; }
      { path = "/Applications/1Password.app/"; }
      { path = "/Applications/iTerm.app/"; }
      { path = "/Users/${user}/Applications/Home Manager Apps/Visual Studio Code.app/"; }
      { path = "/Applications/Spotify.app/"; }
      { path = "/Applications/Slack.app/"; }
      { path = "/Applications/Microsoft Outlook.app/"; }
      { path = "/Applications/Microsoft Teams.app/"; }
      { path = "/Applications/Telegram.app/"; }
      { path = "/Applications/WhatsApp.app/"; }
    ];
  };

  launchd.user.agents.gdrive = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path \"${pkgs.lib.getExe pkgs.rclone}\" &amp;&amp; exec \"${pkgs.lib.getExe pkgs.rclone}\" mount gdrive:/ /Users/${user}/gdrive"
      ];
      UserName = user;
      RunAtLoad = true;
      KeepAlive = {
        NetworkState = true;
      };
      # StandardOutPath = /Users/${user}/gdrive.log;
      # StandardErrorPath = /Users/${user}/gdrive.err;
    };
  };

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    activationScripts.postActivation.text = ''
      # enable this the first time. disable later for speed.
      # softwareupdate --install-rosetta --agree-to-license

      # lock screen
      # TODO

      # dock
      sudo -u ${user} defaults write com.apple.dock autohide -bool true
      sudo -u ${user} defaults write com.apple.dock magnification -bool false
      sudo -u ${user} defaults write com.apple.dock show-recents -bool false
      sudo -u ${user} defaults write com.apple.dock launchanim -bool true
      sudo -u ${user} defaults write com.apple.dock orientation -string "bottom"
      sudo -u ${user} defaults write com.apple.dock tilesize -int 64

      # trackpad
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad DragLock -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad Dragging -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadHandResting -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0
      sudo -u ${user} defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

      # Keyboard
      # 120, 94, 68, 35, 25, 15
      sudo -u ${user} defaults write NSGlobalDomain InitialKeyRepeat -int 15
      # 120, 90, 60, 30, 12, 6, 2
      sudo -u ${user} defaults write NSGlobalDomain KeyRepeat -int 2
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
      sudo -u ${user} defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
      sudo -u ${user} defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
      sudo -u ${user} defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

      # Sounds
      sudo -u ${user} defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.0
      sudo -u ${user} defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool false
      sudo -u ${user} defaults write NSGlobalDomain AppleShowAllExtensions -bool false

      # Ctrl + scroll = zoom
      #sudo -u ${user} defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
      #sudo -u ${user} defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
      
      # Finder
      sudo -u ${user} defaults write com.apple.finder ShowPathbar -bool true
      # Disable .DS_Store File Creation
      sudo -u ${user} defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
      sudo -u ${user} defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

      # Expand Save and Print Dialogs by Default
      sudo -u ${user} defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
      sudo -u ${user} defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
      sudo -u ${user} defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
      sudo -u ${user} defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

      # Disable AutoCorrect
      sudo -u ${user} defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
      # Disables auto capitalization
      sudo -u ${user} defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
      # Disables "smart" dashes
      sudo -u ${user} defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
      # Disables automatic period substitutions
      sudo -u ${user} defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
      # Disables smart quotes 
      sudo -u ${user} defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

      # Spotlight
      # this would be shorter with defaults write, but this works
      # TODO: loop
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Delete :orderedItems"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems array"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string APPLICATIONS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool true"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MENU_EXPRESSION"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool true"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string CONTACT"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MENU_CONVERSION"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool true"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MENU_DEFINITION"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string SOURCE"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string DOCUMENTS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string EVENT_TODO"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string DIRECTORIES"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string FONTS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string IMAGES"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MESSAGES"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MOVIES"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MUSIC"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MENU_OTHER"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string PDF"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string PRESENTATIONS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string MENU_SPOTLIGHT_SUGGESTIONS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string SPREADSHEETS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string SYSTEM_PREFS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool true"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string TIPS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string BOOKMARKS"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool false"

      # Don't slightly dim display on battery
      pmset -b lessbright 0
      # Don't wake on LAN (magic packet)
      pmset -b womp 0
      pmset -a womp 0

      # Don't automatically adjust brightness
      # TODO: this doesn't seem to stick :(
      # displayID=`/usr/libexec/PlistBuddy "/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist" -c "Print :DisplayPreferences:" | grep "= Dict" | grep -v AutoBrightnessCurve | awk '{print $1}'`
      # /usr/libexec/PlistBuddy "/private/var/root/Library/Preferences/com.apple.CoreBrightness.plist" -c "Set :DisplayPreferences:$displayID:AutoBrightnessEnable 0"

      # Disable MacAppStore updates https://lapcatsoftware.com/articles/mas-notifications.html
      defaults write com.apple.appstored LastUpdateNotification -date "2029-12-12 12:00:00 +0000"

      # Menubar
      defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
      sudo -u ${user} defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true
      sudo -u ${user} defaults write com.apple.menuextra.clock ShowAMPM -bool true
      sudo -u ${user} defaults write com.apple.menuextra.clock ShowDate -bool true
      sudo -u ${user} defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

      # iTerm2
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Normal Font' 'HackNFM-Regular 12'"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Scrollback Lines' 10000"
      /usr/libexec/PlistBuddy /Users/${user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Custom Directory' Recycle"

      # refresh settings
      sudo -u ${user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      killall Dock
      # this makes spotlight categories stick https://community.jamf.com/t5/jamf-pro/spotlight-customization/m-p/52579
      killall cfprefsd
    '';
  };
}
