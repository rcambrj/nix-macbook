# inspired by https://github.com/NixOS/nixpkgs/blob/4ef5937cf6fb0784049a3a383cc82dfe39f53414/nixos/modules/profiles/macos-builder.nix
{ flake, inputs, modulesPath, ... }:
let
  inherit (flake.lib) me;
  user = "nixos";
in  {
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
  services.getty.autologinUser = user;
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [ flake.lib.ssh-keys.rcambrj ];
  };
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.nameservers = [ "1.1.1.1" ];

  nix.settings = {
    trusted-users = [ user ];
  };

  virtualisation = {
    vmVariant = {
      virtualisation = {
        host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;

        diskSize = 50 * 1024;
        memorySize = 4 * 1024;
        forwardPorts = [
          { from = "host"; guest.port = 22; host.port = 2222; }
        ];
        graphics = false;
        sharedDirectories = {
          projects = {
            source = "/Users/${me.user}/projects";
            target = "/home/${user}/projects";
          };
        };

        useNixStoreImage = true;
        writableStore = true;
        writableStoreUseTmpfs = false;
        useHostCerts = true;
      };
    };
  };
}