{ pkgs, ... }:

(import ./package.nix {
  inherit (pkgs) lib stdenv callPackage;
})
