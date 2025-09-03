# VPC configuration
resource "google_compute_network" "csm-handson-vpc" {
    provider                = google.network
    name                    = var.network_name
    auto_create_subnetworks = true
    routing_mode            = "REGIONAL"
}


# Firewall（tcp:18080, icmp allow）
resource "google_compute_firewall" "csm-handson-fw" {
    provider = google.network

    name    = var.firewall_name
    network = google_compute_network.csm-handson-vpc.self_link

    direction     = "INGRESS"
    source_ranges = var.firewall_source_ranges

    allow {
        protocol = "tcp"
        ports    = ["18080"]
    }

    allow {
        protocol = "icmp"
    }
}
