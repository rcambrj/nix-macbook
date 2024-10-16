{ flake, ... }:
let
  me = import ./me.nix;
in {
  programs.ssh = {
    enable = true;
    extraOptionOverrides  = {
      TCPKeepAlive = "yes";
      ServerAliveInterval = "60";
      ConnectTimeout = "2";
    };
    matchBlocks = {
      "vm" = {
        hostname = "localhost";
        user = me.user;
        port = 2222;
      };
      "router" = {
        hostname =  "192.168.142.1";
        user = "root";
      };
      "blueberry" = {
        hostname =  "blueberry.cambridge.me";
        user = "nixos";
      };
      "cranberry" = {
        hostname =  "cranberry.cambridge.me";
        user = "nixos";
      };
      "minimal-intel" = {
        hostname =  "minimal-intel-nomad.local";
        user = "nixos";
        extraOptions = {
          # this will boot on a variety of shapes
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "minimal-raspi" = {
        hostname =  "minimal-raspi-nomad.local";
        user = "nixos";
        extraOptions = {
          # this will boot on a variety of shapes
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "gooseberry" = {
        hostname =  "gooseberry.cambridge.me";
        user = "gooseberry";
      };
      "tacx" = {
        hostname =  "tacx.lan";
        user = "pi";
      };
      "tomato" = {
        hostname =  "tomato.cambridge.me";
        user = "root";
      };
      "coconut" = {
        hostname = "coconut.cambridge.me";
        user = "root";
      };
      "lime" = {
        hostname = "51.255.83.152";
        user = "root";
        port = 15120;
      };
      "apple" = {
        hostname = "apple.cambridge.me";
        user = "ubuntu";
      };
      "orange" = {
        hostname = "orange.cambridge.me";
        user = "ubuntu";
      };
    };
  };
}