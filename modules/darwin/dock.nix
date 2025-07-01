# https://github.com/dustinlyons/nixos-config/blob/main/modules/darwin/dock/default.nix

{ config, pkgs, lib, system, ... }:

with lib;
let
  cfg = config.dock;
  inherit (pkgs) stdenv dockutil;
in
{
  options = {
    dock.enable = mkOption {
      description = "Enable dock";
      default = stdenv.isDarwin;
      example = false;
    };

    dock.entries = mkOption
      {
        description = "Entries on the Dock";
        type = with types; listOf (submodule {
          options = {
            path = lib.mkOption { type = str; };
            section = lib.mkOption {
              type = str;
              default = "apps";
            };
            options = lib.mkOption {
              type = str;
              default = "";
            };
          };
        });
        readOnly = true;
      };
  };

  config =
    mkIf cfg.enable
      (
        let
          createEntries = concatMapStrings
            (entry: "${dockutil}/bin/dockutil --no-restart --add '${entry.path}' --section ${entry.section} ${entry.options}\n")
            cfg.entries;
        in
        {
          system.activationScripts.configureDock.text = ''
            ${dockutil}/bin/dockutil --no-restart --remove all
            ${createEntries}
            killall Dock
            echo >&2 "Dock setup complete."
          '';
        }
      );
}