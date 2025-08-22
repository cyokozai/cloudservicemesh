variable "fleet_project_id" {
    description = "Fleet（CSM 管理）用の GCP プロジェクト ID"
    type        = string
}


variable "cluster_project_id" {
    description = "GKE クラスタを作成する GCP プロジェクト ID"
    type        = string
}


variable "network_project_id" {
    description = "VPC/Firewall を作成する GCP プロジェクト ID"
    type        = string
}


variable "region" {
    description = "GKE のリージョン"
    type        = string
    default     = "asia-northeast1"
}


variable "network_name" {
    description = "作成する VPC ネットワーク名"
    type        = string
    default     = "csm-vpc"
}


variable "firewall_name" {
    description = "作成する Firewall ルール名"
    type        = string
    default     = "csm-fw"
}


variable "firewall_source_ranges" {
    description = "許可する送信元 CIDR"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}


variable "cluster_name" {
    description = "GKE Autopilot クラスタ名"
    type        = string
    default     = "csm-handson"
}


variable "cluster_labels" {
    description = "クラスタに付与するラベル"
    type        = map(string)
    default = {
        owner = "intern-inoue"
    }
}