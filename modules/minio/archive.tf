locals {
  access_key_file = "/var/keys/minio-access-key"
  secret_key_file = "/var/keys/minio-secret-key"
  data_dir        = "/var/lib/minio/data"
}

module "nixos_minio" {
  source = "../sakuracloud_archive_nixos_custom"
  name   = "sos21_minio_nixos"
  tags   = concat(var.tags, ["sos21_archive_nixos_minio"])
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

    fileSystems."${local.data_dir}" =
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
        RequiresMountsFor = "${local.data_dir}";
      };
      script = ''
        export MINIO_ACCESS_KEY=$(cat ${local.access_key_file})
        export MINIO_SECRET_KEY=$(cat ${local.secret_key_file})
        $${pkgs.sudo}/bin/sudo --preserve-env=MINIO_ACCESS_KEY,MINIO_SECRET_KEY \
          -u $${config.users.users.minio.name} \
          $${pkgs.minio}/bin/minio server --json \
            --address 0.0.0.0:${var.port} \
            ${local.data_dir}
      '';
    };

    networking.firewall.allowedTCPPorts = [ ${var.port} ];

    systemd.services.minio-data-permission = {
      before = [ "minio.service" ];
      requiredBy = [ "minio.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig = {
        RequiresMountsFor = "${local.data_dir}";
      };
      script = ''
        chown -R $${config.users.users.minio.name}:$${config.users.users.minio.group} \
          ${local.data_dir}
      '';
    };
  }
  EOT
  secret_contents = [
    {
      target  = local.access_key_file
      content = random_password.access_key.result
      mode    = "600"
    },
    {
      target  = local.secret_key_file
      content = random_password.secret_key.result
      mode    = "600"
    }
  ]
}
