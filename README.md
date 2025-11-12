# Nix Macbook configuration

## Uninstall

* `sudo darwin-uninstaller`

* `sudo /nix/nix-installer uninstall`

## Install

* install [DeterminateSystems' nix](https://github.com/DeterminateSystems/nix-installer)

    > [!IMPORTANT]
    > `--case-insensitive` is critical due to `nix.settings.use-case-hack = false`.
    > Disabling the case hack leads to unpredictable behaviour.

    ```
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install macos --case-sensitive --prefer-upstream-nix
    ```

    > prefer OG nix because Determinate Nix flake cannot manage `/etc/nix.conf` with `nix.settings.*`, all config must go into `/etc/nix.custom.conf`. This last file may be managed with `environment.etc` or `systemd.tmpfiles`, but I've not confirmed.

* In Spotlight search `Full Disk Access` and grant `nix` access.

* `sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#macbook`

    
* Authenticate:
    * 1Password
    * Google Drive
    * Firefox
    * Discord
    * Slack
    * Telegram
    * Whatsapp
    * Messenger
    * Spotify
    * Private Internet Access
* `rclone config` for gdrive
* Download + install Paragon extFS
    * authenticate licence
* Start once + start on login:
	* iBar
    * ZeroTier
        * join network
    * Arq
        * configure licence
        * configure /Users/rcambrj with `ArqFileSelections.json`
    * Choosy
        * configure licence
        * set default browser
        * configure browsers
        * do not expand URLs
        * remove rule "prompt from running browsers"
    * Lunar
        * configure licence
        * disable `Check for network light sensors periodically`
    * Rectangle
    * Hot
        * Ignore sensors: Tf06 Tf16 Tf26 Tf36 Tf46
    * Postman Agent
    * Music Decoy
    * Battery
        * `battery maintain 60`
    * Mac Fan Control
    * Youtube Music (create PWA from Chrome)
* Remove all notification panel widgets
* Set `Automatically dim brightness` off
* Set `True Tone` off

...make changes...

* `dwu` (darwin update)

## Tips

### Get all MacOS defaults

```
# https://apple.stackexchange.com/questions/195244/concise-compact-list-of-all-defaults-currently-configured-and-their-values

for i in `defaults domains | tr ',' '\n'`; do echo "********* READING DEFAULT DOMAIN $i **********"; echo; defaults read $i; done > defaults.txt
```

### Edit a secret

```
nix run github:ryantm/agenix -- -e secrets/foo.age
```

### Broken things after an update?

`System Preferences` => `Privacy & Security` => grant terminal permissions to:

* `App Management`
* `Developer Tools`
* `Input Monitoring`
* `Local Network`
