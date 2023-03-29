resource "sakuracloud_packet_filter" "switch" {
  name = "sos23_database_filter_switch"
  zone = var.zone

  expression {
    protocol         = "tcp"
    destination_port = var.port
    source_network   = "${var.switch_network}/${var.switch_netmask}"
  }

  expression {
    protocol         = "tcp"
    destination_port = "32768-61000"
  }

  expression {
    protocol = "icmp"
  }

  expression {
    protocol = "fragment"
  }

  expression {
    protocol = "ip"
    allow    = false
  }
}
