{ config, pkgs, lib, modulesPath, ... }:
let
  cfg = config.virtualisation.sakuracloudServerImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    { ... }:
    {
      imports = [
        ./sakuracloud-server-config.nix
      ];
    }
  '';
in
{
  imports = [
    ./sakuracloud-server-config.nix
  ];

  options = {
    virtualisation.sakuracloudServerImage = with lib; {
      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
      };

      contents = mkOption {
        type = types.listOf (types.submodule {
          options = {
            source = mkOption {
              type = types.path;
            };

            target = mkOption {
              type = types.str;
            };

            mode = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            user = mkOption {
              type = types.nullOr types.str;
              default = null;
            };

            group = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        });
        default = [ ];
      };
    };
  };

  config = {
    system.build.sakuracloudServerImage = import "${pkgs.path}/nixos/lib/make-disk-image.nix" {
      name = "sakuracloud-server-image";
      format = "raw";
      partitionTableType = "legacy";
      contents = [
        {
          source = ./sakuracloud-server-config.nix;
          target = "/etc/nixos/sakuracloud-server-config.nix";
        }
      ] ++ map (lib.filterAttrs (_: v: v != null)) cfg.contents;
      configFile = if cfg.configFile != null then cfg.configFile else defaultConfigFile;
      inherit config lib pkgs;
    };
  };
}
