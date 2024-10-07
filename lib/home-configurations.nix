{ inputs, ... }: usersPath:
  let
    usersPathStr = toString usersPath;

    userDirs = builtins.attrNames (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir usersPathStr)
    );
  in
  {
    packages = lib.genAttrs (import inputs.systems) (system: {
      homeConfigurations = lib.genAttrs userDirs (
        name:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;

            config.allowUnfree = true;
          };

          modules = [
            "${usersPathStr}/${name}/home.nix"
          ];

          extraSpecialArgs = {
            inherit inputs system;
            flake = inputs.self;
            perSystem = lib.mapAttrs (
              _: flake: flake.legacyPackages.${system} or { } // flake.packages.${system} or { }
            ) inputs;
          };
        }
      );
    });
  }