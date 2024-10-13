# inspired by https://github.com/NixOS/nixpkgs/blob/4ef5937cf6fb0784049a3a383cc82dfe39f53414/nixos/modules/profiles/macos-builder.nix
{ config, flake, perSystem, pkgs, ... }:
let
  macbook = import ../macbook.nix;
in  {
  imports = [
    ./secrets.nix
  ];

  system.stateVersion = "23.11";
  services.getty.autologinUser = macbook.main-user;
  users.users.${macbook.main-user} = {
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [ flake.lib.ssh-keys.rcambrj ];

    # uid <1000 breaks isNormalUser. workaround with isSystemUser+attrs
    uid = macbook.main-uid;
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/${macbook.main-user}";
    homeMode = "700";
    useDefaultShell = true;
  };
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.nameservers = [ "1.1.1.1" ];

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id === "org.freedesktop.login1.power-off" && subject.user === "${macbook.main-user}") {
        return "yes";
      } else {
        return "no";
      }
    })
  '';

  age-template.files.cheap-user-ssh-key = {
    vars.content = builtins.elemAt config.age.identityPaths 0;
    content = "$content";
    path = "/home/${macbook.main-user}/.ssh/id_ed25519";
    owner = macbook.main-user;
  };

  services.openssh.hostKeys = [{
    type = "ed25519";
    path = builtins.elemAt config.age.identityPaths 0;
  }];
}