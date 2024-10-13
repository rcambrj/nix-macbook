{ flake, pkgs, ... }:
let
  macbook = import ./macbook.nix;
in {
  environment.systemPackages = with pkgs; [
    colima
    docker-client
  ];

  launchd.user.agents.colima = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path \"${pkgs.lib.getExe pkgs.colima}\" &amp;&amp; PATH=\"/run/current-system/sw/bin:$PATH\" exec \"${pkgs.lib.getExe pkgs.colima}\" start --foreground"
      ];
      UserName = macbook.main-user;
      RunAtLoad = true;
      KeepAlive = true;
      # StandardOutPath = /Users/${macbook.main-user}/colima.log;
      # StandardErrorPath = /Users/${macbook.main-user}/colima.err;
    };
  };
}