{ ... }:
let
  path = "/var/lib/macbook-linux-vm/.ssh";
in {
  age.secrets.macbook-linux-vm-ssh-key.path = "${path}/id_ed25519";
  age.secrets.macbook-linux-vm-ssh-key.symlink = false;
  age.secrets.macbook-linux-vm-ssh-key.owner = "1000";

}