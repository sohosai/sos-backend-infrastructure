{ pkgs ? import nix/pkgs.nix }:

let
  terraform = pkgs.terraform_0_14.withPlugins (plugins: [
    plugins.sakuracloud
  ]);
in
pkgs.mkShell {
  nativeBuildInputs = [
    terraform
  ];
}
