{ pkgs ? import ./pkgs.nix }:
pkgs.terraform_0_14.withPlugins (plugins: [
  plugins.sakuracloud
  plugins.external
  plugins.random
])
