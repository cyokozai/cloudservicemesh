terraform {
    required_version = ">= 1.6.0"

    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "~> 6.0"
        }
    }
}


# Provider configuration
provider "google" {
    project = var.fleet_project_id
    region  = var.region
}


# Provider configuration: Fleet
provider "google" {
    alias   = "fleet"
    project = var.fleet_project_id
    region  = var.region
}


# Provider configuration: Cluster
provider "google" {
    alias   = "cluster"
    project = var.cluster_project_id
    region  = var.region
}


# Provider configuration: Network
provider "google" {
    alias   = "network"
    project = var.network_project_id
    region  = var.region
}


# Enable necessary APIs: Fleet
resource "google_project_service" "fleet_services" {
    for_each = toset([
        "gkehub.googleapis.com",     # Fleet / Membership
        "mesh.googleapis.com",       # Cloud Service Mesh API
        "anthos.googleapis.com",     # Anthos/ASM 周辺
        "container.googleapis.com",  # GKE (念のため)
    ])
    project = var.fleet_project_id
    service = each.key
}


# Enable necessary APIs: Cluster
resource "google_project_service" "cluster_services" {
    for_each = toset([
        "container.googleapis.com",  # GKE
        "compute.googleapis.com",    # ネットワーク参照で必要なことがある
        "gkehub.googleapis.com",     # Fleet 連携
    ])
    project = var.cluster_project_id
    service = each.key
}


# Enable necessary APIs: Network
resource "google_project_service" "network_services" {
    for_each = toset([
        "compute.googleapis.com",    # VPC/Firewall
    ])
    project = var.network_project_id
    service = each.key
}


# GKE Autopilot cluster
resource "google_container_cluster" "csm-handson" {
    provider = google.cluster

    name     = var.cluster_name
    location = var.region

    enable_autopilot = true

    network    = null
    subnetwork = null

    fleet {
        project = var.fleet_project_id
    }

    resource_labels = var.cluster_labels

    depends_on = [
        google_project_service.cluster_services,
        google_project_service.fleet_services,
        google_project_service.network_services,
    ]
}


# Enable Cloud Service Mesh feature
resource "google_gke_hub_feature" "servicemesh" {
    provider = google.fleet

    name     = "servicemesh"
    location = "global"

    depends_on = [
        google_container_cluster.autopilot,
    ]
}

resource "google_project_service" "mesh_api" {
  service = "mesh.googleapis.com"

  disable_dependent_services = true
}


resource "google_gke_hub_feature_membership" "feature_member" {
    location = "global"

    feature = google_gke_hub_feature.feature.name
    
    membership          = google_container_cluster.cluster.fleet.0.membership
    membership_location = google_container_cluster.cluster.location

    mesh {
        management = "MANAGEMENT_AUTOMATIC"
    }
}