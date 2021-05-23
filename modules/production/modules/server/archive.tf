data "sakuracloud_zone" "zone" {
  name = var.zone
}

locals {
  nixos_config = <<-EOT
  { ... }:
  {
    networking.nameservers = [
      ${join(" ", formatlist("\"%s\"", data.sakuracloud_zone.zone.dns_servers))}
    ];

    sos21-production-server = {
      switch = {
        network = "${var.switch_network}";
        ipAddress = "${var.ip_address}";
        prefixLength = ${var.switch_netmask};
      };
      router = {
        network = "${data.sakuracloud_internet.router.network_address}";
        ipAddress = "${var.global_ip_address}";
        prefixLength = ${data.sakuracloud_internet.router.netmask};
        gateway = "${data.sakuracloud_internet.router.gateway}";
      };
      rootAuthorizedKeys = [
        ${join(" ", formatlist("\"%s\"", var.root_ssh_public_keys))}
      ];
      adminUser = {
        name = "${var.user_name}";
        hashedPassword = "${var.user_hashed_password}";
        authorizedKeys = [
          ${join(" ", formatlist("\"%s\"", var.user_ssh_public_keys))}
        ];
      };
    };
  }
  EOT
}

module "nixos_archive" {
  source = "../../../sakuracloud_archive_nixos_custom"
  name   = "sos21_production_nixos"
  tags   = concat(var.tags, ["sos21_archive_nixos"])
  zone   = var.zone

  imports      = ["${path.module}/sos21-production-server.nix"]
  nixos_config = local.nixos_config

  secret_contents = var.secret_contents
  contents = concat(var.contents, [
    {
      target  = "/etc/nixos/base-config.nix"
      content = local.nixos_config
    },
    {
      target  = "/etc/nixos/sos21-production-server.nix"
      content = file("${path.module}/sos21-production-server.nix")
    }
  ])
}
