{ pkgs ? import nix/pkgs.nix }:
let
  terraform = pkgs.terraform_0_14.withPlugins (plugins: [
    plugins.sakuracloud
    plugins.external
  ]);
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    terraform
    util-linux
    coreutils
    jq
    nix
    cacert
    libguestfs
    mktemp
  ];
  LIBGUESTFS_PATH = "${pkgs.libguestfs-appliance}";
}
