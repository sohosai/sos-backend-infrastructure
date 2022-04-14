locals {
  access_key_file = "/var/keys/minio-access-key"
  secret_key_file = "/var/keys/minio-secret-key"
}

module "nixos_minio" {
  source = "../sakuracloud_archive_nixos_custom"
  name   = "sos22_minio_nixos"
  tags   = concat(var.tags, ["sos22_archive_nixos_minio"])
  zone   = var.zone

  imports      = ["${path.module}/sos22-minio.nix"]
  nixos_config = <<-EOT
  { pkgs, ... }:
  {
    sos22-minio = {
      network = "${var.switch_network}";
      ipAddress = "${var.ip_address}";
      prefixLength = ${var.switch_netmask};
      port = ${var.port};
      package = pkgs.minio;
      accessKeyFile = ${local.access_key_file};
      secretKeyFile = ${local.secret_key_file};
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
