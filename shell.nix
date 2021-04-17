{ pkgs ? import nix/pkgs.nix }:
let
  terraform = import ./nix/terraform.nix { inherit pkgs; };
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
    nixpkgs-fmt
    shellcheck
  ];
  LIBGUESTFS_PATH = "${pkgs.libguestfs-appliance}";
}
