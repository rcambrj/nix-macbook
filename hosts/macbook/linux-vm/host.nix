{ flake, inputs, pkgs, ... }:
let
  macbook = import ../macbook.nix;
  workingDirectory = "/Users/${macbook.main-user}/.linux-vm";
  agenixIdentityPath = "${workingDirectory}/agenix-identity";
  vmSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] pkgs.stdenv.hostPlatform.system;
  vm = inputs.nixpkgs.lib.nixosSystem {
      system = vmSystem;
      specialArgs = {
        inherit inputs flake;
        perSystem = pkgs.lib.mapAttrs (
          _: flake: flake.legacyPackages.${vmSystem} or { } // flake.packages.${vmSystem} or { }
        ) inputs;
      };
      modules = [
        ./guest.nix
        { virtualisation = { vmVariant = { virtualisation = {
            diskImage = "${workingDirectory}/disk.qcow2";
            host.pkgs = pkgs;

            writableStore = true;
            writableStoreUseTmpfs = false;
            graphics = false;

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
            sharedDirectories = {
              agenix-identity = {
                source = "${agenixIdentityPath}";
                target = "/var/lib/agenix-identity";
              };
              projects = {
                source = "/Users/${macbook.main-user}/projects";
                target = "/home/${macbook.main-user}/projects";
              };
            };
          }; }; };
        }
      ];
    };
    command = vm.config.system.build.vm;
in {
  age.secrets.macbook-linux-vm-ssh-key.path = "${agenixIdentityPath}/id_ed25519";
  age.secrets.macbook-linux-vm-ssh-key.symlink = false;
  age.secrets.macbook-linux-vm-ssh-key.owner = macbook.main-user;

  launchd.user.agents.linux-vm = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path \"${pkgs.lib.getExe command}\" &amp;&amp; exec \"${pkgs.lib.getExe command}\""
      ];
      UserName = macbook.main-user;
      RunAtLoad = true;
      StandardOutPath = builtins.toPath "${workingDirectory}/stdout.log";
      StandardErrorPath = builtins.toPath "${workingDirectory}/stderr.log";
      KeepAlive = true;
    };
  };
}