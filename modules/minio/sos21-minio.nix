{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.sos21-minio;
in
{
  options = {
    sos21-minio = {
      network = mkOption {
        type = types.str;
      };

      ipAddress = mkOption {
        type = types.str;
      };

      prefixLength = mkOption {
        type = types.int;
      };

      port = mkOption {
        type = types.port;
      };

      package = mkOption {
        type = types.package;
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/minio/data";
      };

      accessKeyFile = mkOption {
        type = types.path;
      };

      secretKeyFile = mkOption {
        type = types.path;
      };
    };
  };

  config = {
    networking.interfaces.ens3 = {
      useDHCP = false;
      ipv4 = {
        routes = [
          {
            address = cfg.network;
            inherit (cfg) prefixLength;
          }
        ];
        addresses = [
          {
            address = cfg.ipAddress;
            inherit (cfg) prefixLength;
          }
        ];
      };
    };

    fileSystems."${cfg.dataDir}" =
      {
        device = "/dev/vdb";
        fsType = "ext4";
        autoFormat = true;
      };

    users.users.minio = {
      group = "minio";
      uid = config.ids.uids.minio;
    };

    users.groups.minio.gid = config.ids.gids.minio;

    systemd.services.minio = {
      requires = [ "minio-data-permission.service" ];
      after = [
        "minio-data-permission.service"
        "network.target"
      ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        LimitNOFILE = 65536;
      };
      unitConfig = {
        RequiresMountsFor = cfg.dataDir;
      };
      script = ''
        export MINIO_ACCESS_KEY=$(cat ${toString cfg.accessKeyFile})
        export MINIO_SECRET_KEY=$(cat ${toString cfg.secretKeyFile})
        ${pkgs.sudo}/bin/sudo --preserve-env=MINIO_ACCESS_KEY,MINIO_SECRET_KEY \
          -u ${config.users.users.minio.name} \
          ${cfg.package}/bin/minio server --json \
            --address 0.0.0.0:${toString cfg.port} \
            ${toString cfg.dataDir}
      '';
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.minio-data-permission = {
      before = [ "minio.service" ];
      requiredBy = [ "minio.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig = {
        RequiresMountsFor = cfg.dataDir;
      };
      script = ''
        chown -R ${config.users.users.minio.name}:${config.users.users.minio.group} \
          ${toString cfg.dataDir}
      '';
    };
  };
}
