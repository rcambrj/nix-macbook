
let
  sshKeys = import ./lib/ssh-keys.nix;
in {
  "secrets/macbook-linux-vm-ssh-key.age".publicKeys = [ sshKeys.rcambrj ];
}