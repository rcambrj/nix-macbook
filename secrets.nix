
let
  sshKeys = import ./lib/ssh-keys.nix;
in {
  "secrets/macbook-linux-vm-ssh-key.age".publicKeys = [ sshKeys.rcambrj ];
  "secrets/foo.age".publicKeys = [ sshKeys.rcambrj sshKeys.linux-vm ];

  # openrouter.ai
  "secrets/openrouter-ai-key.age".publicKeys = [ sshKeys.rcambrj sshKeys.linux-vm ];
}