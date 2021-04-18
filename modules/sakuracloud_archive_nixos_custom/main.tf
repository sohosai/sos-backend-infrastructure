data "external" "build_disk_image" {
  # FIXME: Running concurrently will fail
  program = ["flock", "-x", "${path.module}/.build.lock", "${path.module}/build_disk_image.sh"]

  query = {
    nixos_config    = var.nixos_config
    contents        = jsonencode(var.contents)
    secret_contents = jsonencode(var.secret_contents)
  }
}

resource "sakuracloud_archive" "nixos" {
  name         = var.name
  description  = data.external.build_disk_image.result.id
  archive_file = "${abspath(path.module)}/${data.external.build_disk_image.result.output_relative}"
  zone         = var.zone
  tags         = var.tags
}
