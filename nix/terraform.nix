{ pkgs ? import ./pkgs.nix }:
pkgs.terraform.withPlugins (plugins: [
  plugins.sakuracloud
  plugins.external
  plugins.random
  plugins.cloudflare
])
