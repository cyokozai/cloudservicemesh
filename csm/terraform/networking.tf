# ---------------------------
# VPC ネットワーク（--subnet-mode auto, --bgp-routing-mode REGIONAL）
# ---------------------------
resource "google_compute_network" "csm_vpc" {
    provider                = google.network
    name                    = var.network_name
    auto_create_subnetworks = true      # --subnet-mode auto
    routing_mode            = "REGIONAL" # --bgp-routing-mode REGIONAL
}

# ---------------------------
# Firewall（tcp:18080, icmp 許可）
# ---------------------------
resource "google_compute_firewall" "csm_fw" {
    provider = google.network

    name    = var.firewall_name
    network = google_compute_network.csm_vpc.self_link

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

# GKE main.tf で参照しやすいように Self Link を出力用に locals へ
locals {
    network_self_link = google_compute_network.csm_vpc.self_link
}
