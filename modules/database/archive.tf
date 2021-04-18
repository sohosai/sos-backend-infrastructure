locals {
  password_file = "/var/keys/database-password"
}

module "nixos_database" {
  source = "../sakuracloud_archive_nixos_custom"
  name   = "sos21_database_nixos"
  tags   = concat(var.tags, ["sos21_archive_nixos_database"])
  zone   = var.zone
  # TODO: Separate Nix expression
  nixos_config = <<-EOT
  { pkgs, lib, config, ... }:
  {
    networking.interfaces.ens3 = {
      useDHCP = false;
      ipv4 = {
        routes = [
          {
            address = "${var.switch_network}";
            prefixLength = ${var.switch_netmask};
          }
        ];
        addresses = [
          {
            address = "${var.ip_address}";
            prefixLength = ${var.switch_netmask};
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
      package = pkgs.postgresql_13;
      enableTCPIP = true;
      port = ${var.port};
      dataDir = "/var/lib/postgresql/$${config.services.postgresql.package.psqlSchema}";
      authentication = ''
        local all all peer
        host all ${random_password.username.result} ${var.switch_network}/${var.switch_netmask} scram-sha-256
      '';
      initialScript = pkgs.writeText "initialScript" ''
        CREATE USER "${random_password.username.result}" WITH SUPERUSER;
      '';
      settings = {
        password_encryption = "scram-sha-256";
      };
    };

    networking.firewall.allowedTCPPorts = [ ${var.port} ];

    systemd.services.postgresql-prepare-data-dir = {
      before = [ "postgresql.service" ];
      requiredBy = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig = {
        RequiresMountsFor = "$${config.services.postgresql.dataDir}";
      };
      script = ''
        mkdir -p $${config.services.postgresql.dataDir}
        chmod 750 $${config.services.postgresql.dataDir}
        chown -R $${config.users.users.postgres.name}:$${config.users.users.postgres.group} \
          $${config.services.postgresql.dataDir}
      '';
    };

    systemd.services.postgresql-password = {
      after = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        PASSWORD=$(cat ${local.password_file})
        $${pkgs.sudo}/bin/sudo -u $${config.users.users.postgres.name} \
          $${pkgs.postgresql_13}/bin/psql -tA -c 'ALTER USER "${random_password.username.result}" LOGIN PASSWORD '"'$PASSWORD'"
      '';
    };
  }
  EOT
  secret_contents = [
    {
      target  = local.password_file
      content = random_password.password.result
      mode    = "600"
    }
  ]
}
