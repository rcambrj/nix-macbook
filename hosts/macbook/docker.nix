{ flake, pkgs, ... }:
let
  inherit (flake.lib) me;
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
      UserName = me.user;
      RunAtLoad = true;
      KeepAlive = true;
      # StandardOutPath = /Users/${me.user}/colima.log;
      # StandardErrorPath = /Users/${me.user}/colima.err;
    };
  };
}