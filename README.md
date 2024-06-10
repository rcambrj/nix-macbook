# MacOS nix configuration

## Getting started

* Install MacFUSE https://osxfuse.github.io/ (for gdrive)
* `/run/current-system/sw/bin/nix run github:LnL7/nix-darwin -- switch --flake .#rcambrj`
* `home-manager switch --flake .#rcambrj`
* `rclone config` for gdrive
* Authenticate:
    * 1Password
    * Firefox
    * Discord
    * Slack
    * Telegram
    * Whatsapp
    * Spotify
    * Private Internet Access
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

...make changes...

* `dwu` (darwin update)
* `dwa` (darwin activate)
* `hmu` (home manager update)

## Tips

### Get all MacOS defaults

```
# https://apple.stackexchange.com/questions/195244/concise-compact-list-of-all-defaults-currently-configured-and-their-values

for i in `defaults domains | tr ',' '\n'`; do echo "********* READING DEFAULT DOMAIN $i **********"; echo; defaults read $i; done > defaults.txt
```