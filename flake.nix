{
  inputs = {
    nixpkgs.url = "nixpkgs/24.05";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # newrepo = {
    #   url = "github:foo/bar";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    mach-composer = {
      url = "github:rcambrj/mach-composer-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{
    nixpkgs,
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    nix-vscode-extensions,
    mach-composer,
    # newrepo,
    ...
  }: let
    system = "aarch64-darwin";
    me = import ./me.nix;
    pkgs =
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # allowBroken = true;
          # allowInsecure = false;
          # allowUnsupportedSystem = true;
        };
        overlays = [
          mach-composer.overlays.default
          # newrepo.overlays.default
        ];
      };

    nixVscodeExtensions = nix-vscode-extensions.extensions.${system};
  in
  {
    darwinConfigurations.rcambrj = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs pkgs system; };
      modules = [
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = me.user;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
            mutableTaps = false;
          };
        }
        ./darwin-configuration.nix
      ];
    };
    homeConfigurations.rcambrj = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs pkgs system nixVscodeExtensions; };
      modules = [
        ./home-manager.nix
      ];
    };

  };
}
