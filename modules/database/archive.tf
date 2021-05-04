locals {
  password_file = "/var/keys/database-password"
}

module "nixos_database" {
  source = "../sakuracloud_archive_nixos_custom"
  name   = "sos21_database_nixos"
  tags   = concat(var.tags, ["sos21_archive_nixos_database"])
  zone   = var.zone

  imports      = ["${path.module}/sos21-database.nix"]
  nixos_config = <<-EOT
  { pkgs, ... }:
  {
    sos21-database = {
      network = "${var.switch_network}";
      ipAddress = "${var.ip_address}";
      prefixLength = ${var.switch_netmask};
      port = ${var.port};
      package = pkgs.postgresql_13;
      username = "${random_password.username.result}";
      passwordFile = ${local.password_file};
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
