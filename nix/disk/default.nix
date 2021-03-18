{ pkgs ? import ../pkgs.nix
, configFile ? null
, additionalImports ? [ ]
, contents ? [ ]
}:
let
  configuration = { ... }: {
    imports = [
      ./sakuracloud-server-image.nix
    ] ++ additionalImports;

    virtualisation.sakuracloudServerImage = {
      inherit configFile contents;
    };
  };

  system = "x86_64-linux";

  machine = import "${pkgs.path}/nixos" { inherit system configuration; };
in
machine.config.system.build.sakuracloudServerImage
