# https://lastlog.de/blog/vscodium_and_nix_develop.html#how-shell-is-detected
{ inputs, pkgs, ... }: {
  imports = [
    inputs.vscode-server.nixosModules.default
  ];

  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  services.vscode-server = {
    enable = true;
    extraRuntimeDependencies = with pkgs; [
      bash
    ];
  };
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    pkgs.rust-bin.stable.latest.default

    # gets auto-installed to /home/rcambrj/.vscodium-server/extensions/rust-lang.rust-analyzer-0.3.2162-linux-arm64/
    # inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}.vscode-marketplace.rust-lang.rust-analyzer
  ];
}