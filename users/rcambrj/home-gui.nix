{ pkgs, ... }: {
  imports = [
    ./home.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    _1password
    asciinema
  ];
}