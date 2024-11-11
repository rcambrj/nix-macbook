{ flake, ... }:
let
  me = import ./me.nix;
in {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      TCPKeepAlive = yes
      ServerAliveInterval = 60
      ConnectTimeout = 60
    '';
    matchBlocks = {
      "vm" = {
        hostname = "localhost";
        user = me.user;
        port = 2222;
        extraOptions = {
          # mitm unlikely to localhost
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "router" = {
        hostname =  "192.168.142.1";
        user = "root";
      };
      "blueberry" = {
        # auth and home assistant
        hostname =  "blueberry.cambridge.me";
        user = "nixos";
      };
      "cranberry" = {
        # media
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
        # 3d printer nanopi
        hostname =  "gooseberry.cambridge.me";
        user = "gooseberry";
      };
      "lingonberry" = {
        # tacx raspi
        hostname =  "lingonberry.cambridge.me";
        user = "pi";
      };
      "blackberry" = {
        # paper printer raspi
        hostname = "blackberry.cambridge.me";
        user = "pi";
      };
      "tomato" = {
        # racknerd shitbox
        hostname =  "tomato.cambridge.me";
        user = "root";
      };
      "coconut" = {
        # serverhost shitbox
        hostname = "coconut.cambridge.me";
        user = "root";
      };
      "lime" = {
        # gullo's shitbox
        hostname = "51.255.83.152";
        user = "root";
        port = 15120;
      };
      "apple" = {
        # oracle cloud free x86_64
        hostname = "apple.cambridge.me";
        user = "root";
      };
      "orange" = {
        # oracle cloud free aarch64
        hostname = "orange.cambridge.me";
        user = "ubuntu";
      };
    };
  };
}