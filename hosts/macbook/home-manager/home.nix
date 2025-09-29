{ config, inputs, pkgs, ... }: {
  imports = [
    inputs.agenix.homeManagerModules.default
    # TODO: add home-manager support to agenix-template
    # inputs.agenix-template.homeManagerModules.default
    inputs.dotfiles.homeModules.rcambrj-console
    inputs.dotfiles.homeModules.vscode
  ];

  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

  home.packages = with pkgs; [
    _1password-cli
  ];

  home.stateVersion = "23.11";
}
