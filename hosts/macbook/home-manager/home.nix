{ pkgs, ... }: {
  imports = [
    ../../../users/rcambrj/home.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    _1password
  ];
}