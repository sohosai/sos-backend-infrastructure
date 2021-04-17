data "sakuracloud_zone" "zone" {
  name = var.zone
}

locals {
  # TODO: Separate Nix expression
  nixos_config = <<-EOT
  { ... }:
  {
    users.users.root.openssh.authorizedKeys.keys = [
      "${var.ssh_public_key}"
    ];

    networking.dhcpcd.enable = false;
    networking.nameservers = [
      ${join(" ", formatlist("\"%s\"", data.sakuracloud_zone.zone.dns_servers))}
    ];
    networking.defaultGateway = {
      address = "${data.sakuracloud_internet.router.gateway}";
      interface = "ens3";
    };
    networking.interfaces.ens3 = {
      useDHCP = false;
      ipv4 = {
        routes = [
          {
            address = "${data.sakuracloud_internet.router.network_address}";
            prefixLength = ${data.sakuracloud_internet.router.netmask};
          }
        ];
        addresses = [
          {
            address = "${var.global_ip_address}";
            prefixLength = ${data.sakuracloud_internet.router.netmask};
          }
        ];
      };
    };
    networking.interfaces.ens4 = {
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
  }
  EOT
}

module "nixos_archive" {
  source          = "../../../sakuracloud_archive_nixos_custom"
  name            = "sos21_staging_nixos"
  tags            = concat(var.tags, ["sos21_archive_nixos"])
  zone            = var.zone
  nixos_config    = local.nixos_config
  secret_contents = var.secret_contents
  contents = concat(var.contents, [{
    target  = "/etc/nixos/base-config.nix"
    content = local.nixos_config
  }])
}
