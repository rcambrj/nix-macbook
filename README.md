# Nix Macbook configuration

## Getting started

* `/run/current-system/sw/bin/nix run github:LnL7/nix-darwin -- switch --flake .#macbook`
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
    * Rectangle
    * Hot
    * Postman Agent
    * Music Decoy
    * Battery
        * `battery maintain 60`
    * Mac Fan Control
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