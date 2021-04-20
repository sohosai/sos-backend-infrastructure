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
    libguestfs
    mktemp
    nixpkgs-fmt
    shellcheck
    bash
  ];
  LIBGUESTFS_PATH = "${pkgs.libguestfs-appliance}";
}
