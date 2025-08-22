# VPC / Firewall
output "vpc_name" {
    description = "作成した VPC 名"
    value       = google_compute_network.csm_vpc.name
}

output "vpc_self_link" {
    description = "作成した VPC の self_link"
    value       = google_compute_network.csm_vpc.self_link
}

output "firewall_name" {
    description = "作成した Firewall 名"
    value       = google_compute_firewall.csm_fw.name
}

# GKE
output "cluster_name" {
    description = "GKE Autopilot クラスタ名"
    value       = google_container_cluster.autopilot.name
}

output "cluster_location" {
    description = "GKE クラスタのリージョン"
    value       = google_container_cluster.autopilot.location
}

output "cluster_endpoint" {
    description = "GKE API エンドポイント"
    value       = google_container_cluster.autopilot.endpoint
}

# Fleet / Mesh
output "fleet_project" {
  description = "Fleet 管理プロジェクト"
  value       = var.fleet_project_id
}

output "servicemesh_feature" {
    description = "Service Mesh フィーチャー名"
    value       = google_gke_hub_feature.servicemesh.name
}
