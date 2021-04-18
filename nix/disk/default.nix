{ pkgs ? import ../pkgs.nix
, configFile ? null
, additionalImports ? [ ]
, contents ? [ ]
, useKvm ? true
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
  image = machine.config.system.build.sakuracloudServerImage;
in
if useKvm then image else
  with pkgs.lib;
  overrideDerivation image (oldAttrs: {
    requiredSystemFeatures = remove "kvm" oldAttrs.requiredSystemFeatures;
  })
