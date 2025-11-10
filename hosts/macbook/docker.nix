{ flake, pkgs, ... }:
with flake.lib;
{
  environment.systemPackages = with pkgs; [
    colima
    docker-client
  ];

  launchd.user.agents.colima = {
    script = "${pkgs.lib.getExe pkgs.colima} start --foreground";
    serviceConfig = {
      UserName = macbook.main-user;
      RunAtLoad = true;
      KeepAlive = true;
      # StandardOutPath = /Users/${macbook.main-user}/colima.log;
      # StandardErrorPath = /Users/${macbook.main-user}/colima.err;
    };
  };
}