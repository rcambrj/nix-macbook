{ flake, pkgs, ... }:
let
  inherit (flake.lib) me;
  sshConfigPath = "/var/lib/macbook-linux-vm/.ssh";
  inherit (flake.nixosConfigurations.macbook-linux-vm.config.system.build) vm;
in {
  age.secrets.macbook-linux-vm-ssh-key.path = "${sshConfigPath}/id_ed25519";
  age.secrets.macbook-linux-vm-ssh-key.symlink = false;
  age.secrets.macbook-linux-vm-ssh-key.owner = "1000";

  launchd.user.agents.linux-vm = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path \"${pkgs.lib.getExe vm}\" &amp;&amp; exec \"${pkgs.lib.getExe vm}\""
      ];
      UserName = me.user;
      RunAtLoad = true;
      StandardOutPath = /Users/${me.user}/linux-vm.log;
      StandardErrorPath = /Users/${me.user}/linux-vm.err;
    };
  };

  environment.systemPackages = [
    vm
  ];
}