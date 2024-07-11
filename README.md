# Nix Macbook configuration

## Getting started

* `/run/current-system/sw/bin/nix run github:LnL7/nix-darwin -- switch --flake .#rcambrj`
* `home-manager switch --flake .#rcambrj`
* Authenticate:
    * 1Password
    * Firefox
    * Discord
    * Slack
    * Telegram
    * Whatsapp
    * Messenger
    * Spotify
    * Private Internet Access
* `rclone config` for gdrive
* Start once:
    * Choosy
        * configure licence
        * set default browser
        * configure browsers
        * do not expand URLs
        * remove rule "prompt from running browsers"
    * Lunar
        * configure licence
    * Rectangle
    * Hot
    * Postman Agent
    * Topnotch
        * round corners
        * enable on macbook screen only
    * Music Decoy
* Remove all notification panel widgets
* Set `Automatically dim brightness` off
* Set `True Tone` off

...make changes...

* `dwu` (darwin update)
* `hmu` (home manager update)

## Tips

### Get all MacOS defaults

```
# https://apple.stackexchange.com/questions/195244/concise-compact-list-of-all-defaults-currently-configured-and-their-values

for i in `defaults domains | tr ',' '\n'`; do echo "********* READING DEFAULT DOMAIN $i **********"; echo; defaults read $i; done > defaults.txt
```