{ pkgs ? import ./pkgs.nix
, imports ? [ ]
}:
let
  system = "x86_64-linux";
  configuration = { ... }: {
    inherit imports;
  };
  machine = import "${pkgs.path}/nixos" { inherit system configuration; };
in
machine.config.system.build.toplevel
