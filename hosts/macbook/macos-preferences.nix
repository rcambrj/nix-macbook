{ flake, pkgs, ... }:
with flake.lib;
let
  spotlightToggles = {
    APPLICATIONS = true;
    MENU_EXPRESSION = true;
    CONTACT = false;
    MENU_CONVERSION = true;
    MENU_DEFINITION = false;
    SOURCE = false;
    DOCUMENTS = false;
    EVENT_TODO = false;
    DIRECTORIES = false;
    FONTS = false;
    IMAGES = false;
    MESSAGES = false;
    MOVIES = false;
    MUSIC = false;
    MENU_OTHER = false;
    PDF = false;
    PRESENTATIONS = false;
    MENU_SPOTLIGHT_SUGGESTIONS = false;
    SPREADSHEETS = false;
    SYSTEM_PREFS = true;
    TIPS = false;
    BOOKMARKS = false;
  };
in {
  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      nonUS.remapTilde = true;
    };

    activationScripts.postActivation.text = let
      writeDefaultMainUser = "sudo -u ${macbook.main-user} defaults write";
    in ''
      if [ ! -f /Library/Apple/usr/share/rosetta/rosetta ]; then
        echo "Installing rosetta..."
        softwareupdate --install-rosetta --agree-to-license
      fi

      # https://disable-gatekeeper.github.io/
      # TODO: fix "Globally disabling the assessment system needs to be confirmed in System Settings."
      # sudo spctl --master-disable

      # lock screen
      # TODO

      # Wallpaper
      osascript -e "tell application \"System Events\" to tell every desktop to set picture to \"/System/Library/Desktop Pictures/Solid Colors/Black.png\" as POSIX file"

      # dock
      ${writeDefaultMainUser} com.apple.dock autohide -bool true
      ${writeDefaultMainUser} com.apple.dock magnification -bool false
      ${writeDefaultMainUser} com.apple.dock show-recents -bool false
      ${writeDefaultMainUser} com.apple.dock launchanim -bool true
      ${writeDefaultMainUser} com.apple.dock orientation -string "bottom"
      ${writeDefaultMainUser} com.apple.dock tilesize -int 64

      # trackpad
      ${writeDefaultMainUser} NSGlobalDomain com.apple.trackpad.scaling 2
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad Clicking -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad DragLock -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad Dragging -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadHandResting -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 0
      ${writeDefaultMainUser} com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

      # Keyboard
      # 120, 94, 68, 35, 25, 15
      ${writeDefaultMainUser} NSGlobalDomain InitialKeyRepeat -int 15
      # 120, 90, 60, 30, 12, 6, 2
      ${writeDefaultMainUser} NSGlobalDomain KeyRepeat -int 2
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
      ${writeDefaultMainUser} NSGlobalDomain AppleKeyboardUIMode -int 3
      ${writeDefaultMainUser} NSGlobalDomain ApplePressAndHoldEnabled -bool false
      # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
      ${writeDefaultMainUser} NSGlobalDomain AppleKeyboardUIMode -int 3

      # Sounds
      ${writeDefaultMainUser} NSGlobalDomain com.apple.sound.beep.volume -float 0.0
      ${writeDefaultMainUser} NSGlobalDomain com.apple.sound.beep.feedback -bool false
      ${writeDefaultMainUser} NSGlobalDomain AppleShowAllExtensions -bool false

      # Ctrl + scroll = zoom
      #${writeDefaultMainUser} com.apple.universalaccess closeViewScrollWheelToggle -bool true
      #${writeDefaultMainUser} com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

      # Finder
      ${writeDefaultMainUser} com.apple.finder ShowPathbar -bool true
      # Disable .DS_Store File Creation
      ${writeDefaultMainUser} com.apple.desktopservices DSDontWriteNetworkStores -bool true
      ${writeDefaultMainUser} com.apple.desktopservices DSDontWriteUSBStores -bool true

      # Expand Save and Print Dialogs by Default
      ${writeDefaultMainUser} NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
      ${writeDefaultMainUser} NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
      ${writeDefaultMainUser} NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
      ${writeDefaultMainUser} NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

      # Disable AutoCorrect
      ${writeDefaultMainUser} -g NSAutomaticSpellingCorrectionEnabled -bool false
      # Disables auto capitalization
      ${writeDefaultMainUser} NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
      # Disables "smart" dashes
      ${writeDefaultMainUser} NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
      # Disables automatic period substitutions
      ${writeDefaultMainUser} NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
      # Disables smart quotes
      ${writeDefaultMainUser} NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

      # Spotlight
      ${writeDefaultMainUser} com.apple.Spotlight useCount -int 3
      ${writeDefaultMainUser} com.apple.Spotlight showedFTE -bool YES
      # this would be shorter with defaults write, but this works
      # TODO: loop
      /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.apple.spotlight.plist -c "Delete :orderedItems"
      /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems array"

      ${pkgs.lib.strings.concatStringsSep "\n" (builtins.attrValues (pkgs.lib.mapAttrs (name: value: ''
        /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0 dict"
        /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:name string ${name}"
        /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.apple.spotlight.plist -c "Add :orderedItems:0:enabled bool ${pkgs.lib.boolToString value}"
      '') spotlightToggles))}

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
      sudo -u ${macbook.main-user} defaults -currentHost write com.apple.controlcenter.plist BatteryShowPercentage -bool true
      ${writeDefaultMainUser} com.apple.menuextra.clock ShowAMPM -bool true
      ${writeDefaultMainUser} com.apple.menuextra.clock ShowDate -bool true
      ${writeDefaultMainUser} com.apple.menuextra.clock ShowDayOfWeek -bool true

      # iTerm2
      /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Normal Font' 'FiraCodeNFM-Reg 14'"
      /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Scrollback Lines' 100000"
      /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Custom Directory' Recycle"
      /usr/libexec/PlistBuddy /Users/${macbook.main-user}/Library/Preferences/com.googlecode.iterm2.plist -c "Set :'New Bookmarks':0:'Minimum Contrast (Dark)' 0.4"

      # refresh settings
      sudo -u ${macbook.main-user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      killall Dock
      # this makes spotlight categories stick https://community.jamf.com/t5/jamf-pro/spotlight-customization/m-p/52579
      killall cfprefsd

      echo >&2 "MacOS preferences setup complete."
    '';
  };

  launchd.user.agents.killWallpaperVideoExtension = {
    # WallpaperVideoExtension comes alive even if not used
    command = "pgrep WallpaperVideoExtension | xargs kill -9";
    serviceConfig.StartInterval = 30;
  };
}