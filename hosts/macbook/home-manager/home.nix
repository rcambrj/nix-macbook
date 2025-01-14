{ inputs, pkgs, ... }: {
  imports = [
    inputs.dotfiles.homeModules.rcambrj-console
    inputs.dotfiles.homeModules.vscode
  ];

  home.packages = with pkgs; [
    _1password-cli
  ];

  home.stateVersion = "23.11";
  # home.username = me.user;
  # home.homeDirectory = pkgs.lib.mkForce (if pkgs.stdenv.isDarwin then "/Users/${me.user}" else "/home/${me.user}");
  # programs.home-manager.enable = true;
}
