{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.sos21-database;
in
{
  options = {
    sos21-database = {
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

      username = mkOption {
        type = types.str;
      };

      passwordFile = mkOption {
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

    fileSystems."/var/lib/postgresql" =
      {
        device = "/dev/vdb";
        fsType = "ext4";
        autoFormat = true;
      };

    services.postgresql = {
      enable = true;
      inherit (cfg) port package;
      enableTCPIP = true;
      dataDir = "/var/lib/postgresql/${config.services.postgresql.package.psqlSchema}";
      authentication = ''
        local all all peer
        host all ${cfg.username} ${cfg.network}/${toString cfg.prefixLength} scram-sha-256
      '';
      initialScript = pkgs.writeText "initialScript" ''
        CREATE USER "${cfg.username}" WITH SUPERUSER;
      '';
      settings = {
        password_encryption = "scram-sha-256";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.postgresql-prepare-data-dir = {
      before = [ "postgresql.service" ];
      requiredBy = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig = {
        RequiresMountsFor = "${config.services.postgresql.dataDir}";
      };
      script = ''
        mkdir -p ${config.services.postgresql.dataDir}
        chmod 750 ${config.services.postgresql.dataDir}
        chown -R ${config.users.users.postgres.name}:${config.users.users.postgres.group} \
          ${config.services.postgresql.dataDir}
      '';
    };

    systemd.services.postgresql-password = {
      after = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        PASSWORD=$(cat ${toString cfg.passwordFile})
        ${pkgs.sudo}/bin/sudo -u ${config.users.users.postgres.name} \
          ${cfg.package}/bin/psql -tA -c 'ALTER USER "${cfg.username}" LOGIN PASSWORD '"'$PASSWORD'"
      '';
    };
  };
}
