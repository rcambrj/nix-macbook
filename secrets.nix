
let
  publicKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMurhQdqzc/mEE24+yhoCXwtwszxlEr6AeIxqyIIrnJ9" ];
in {
  "secrets/foo.age".publicKeys = publicKeys;
}