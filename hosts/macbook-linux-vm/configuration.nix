# inspired by https://github.com/NixOS/nixpkgs/blob/4ef5937cf6fb0784049a3a383cc82dfe39f53414/nixos/modules/profiles/macos-builder.nix
{ flake, inputs, modulesPath, perSystem, pkgs, ... }:
let
  inherit (flake.lib) me;
  user = "nixos";
in  {
  imports = [
    inputs.agenix.darwinModules.default
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "23.11";
  services.getty.autologinUser = user;
  users.users.${user} = {
    isNormalUser = true;
    uid = 1000;
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

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id === "org.freedesktop.login1.power-off" && subject.user === "${user}") {
        return "yes";
      } else {
        return "no";
      }
    })
  '';

  virtualisation = {
    vmVariant = {
      virtualisation = {
        host.pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;

        diskSize = 50 * 1024;
        memorySize = 4 * 1024;
        forwardPorts = [
          {
            from = "host";
            guest.port = 22;
            host.port = 2222;
            host.address = "127.0.0.1";
          }
        ];
        graphics = false;
        sharedDirectories = {
          home = {
            source = "/var/lib/macbook-linux-vm/.ssh";
            target = "/home/${user}/.ssh";
          };
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


  # services.openssh.hostKeys = [{
  #   type = "ed25519";
  #   path = "/home/${user}/.ssh/id_ed25519";
  # }];

  environment.systemPackages = with pkgs; [
    perSystem.agenix.agenix
  ];
}