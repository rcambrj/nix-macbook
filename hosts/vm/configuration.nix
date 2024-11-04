# inspired by https://github.com/NixOS/nixpkgs/blob/4ef5937cf6fb0784049a3a383cc82dfe39f53414/nixos/modules/profiles/macos-builder.nix
{ config, flake, inputs, lib, modulesPath, perSystem, pkgs, ... }:
with flake.lib;
{
  imports = [
    "${toString modulesPath}/profiles/qemu-guest.nix"
    inputs.home-manager.nixosModules.home-manager
    ./secrets.nix
    # ./vscode-experiment.nix
  ];

  # nix build --print-out-paths -L '.#nixosConfigurations.vm.config.system.build.image'
  system.build.image = (import "${toString modulesPath}/../lib/make-disk-image.nix" {
    inherit lib config pkgs;
    format = "qcow2";
    partitionTableType = "efi";
    touchEFIVars = true;
    copyChannel = false;
    diskSize = "auto";
    additionalSpace = "64M";
  });

  system.stateVersion = "23.11";
  networking.hostName = "vm";
  nixpkgs.hostPlatform = "aarch64-linux";
  nixpkgs.config.allowUnfree = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.kernelParams = [
    "console=ttyAMA0,115200n8"
    "console=tty0"
    "boot.shell_on_fail"
    "root=LABEL=nixos"
  ];
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
    # useDefaultShell = true;
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  # TODO: test if this is necessary?
  networking.nameservers = [ "1.1.1.1" ];

  nix.channel.enable = false;
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
    "/" = {
      # device = "/dev/root";
      device = "/dev/disk/by-label/nixos";
      neededForBoot = true;
      fsType = "ext4";
    };
  };

  systemd.tmpfiles.settings = {
    "10-main-user-ssh" = {
      "/home/${macbook.main-user}/.ssh" = {
        d = {
          user = macbook.main-user;
          group = "users";
          mode = "0700";
        };
      };
    };
  };

  age-template.files.cheap-user-ssh-key = {
    vars.content = builtins.elemAt config.age.identityPaths 0;
    content = "$content";
    path = "/home/${macbook.main-user}/.ssh/id_ed25519";
    owner = macbook.main-user;
    group = "users";
  };

  services.openssh.hostKeys = [{
    type = "ed25519";
    path = builtins.elemAt config.age.identityPaths 0;
  }];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" "armv7l-linux" ];

  home-manager.users.${macbook.main-user}.imports = [ ../../users/rcambrj/home.nix ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs perSystem; };
}