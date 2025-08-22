# ---------------------------
# プロジェクト & リージョン
# ---------------------------
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
    description = "GKE のリージョン（例: asia-northeast1）"
    type        = string
    default     = "asia-northeast1"
}

# ---------------------------
# ネットワーク
# ---------------------------
variable "network_name" {
    description = "作成する VPC ネットワーク名（例: yinoue-csm-vpc）"
    type        = string
    default     = "yinoue-csm-vpc"
}

variable "firewall_name" {
    description = "作成する Firewall ルール名（例: yinoue-csm-fw）"
    type        = string
    default     = "yinoue-csm-fw"
}

variable "firewall_source_ranges" {
    description = "許可する送信元 CIDR（必要に応じて制限してください）"
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

# ---------------------------
# クラスタ
# ---------------------------
variable "cluster_name" {
    description = "GKE Autopilot クラスタ名（例: csm-bookinfo）"
    type        = string
}

variable "cluster_labels" {
    description = "クラスタに付与するラベル"
    type        = map(string)
    default = {
        owner = "intern-inoue"
    }
}

# ---------------------------
# 既存ネットワークを参照したい場合に使う（空なら networking.tf の作成物を使用）
# ---------------------------
variable "network_self_link" {
    description = "既存 VPC の self_link。空ならこのモジュールで作成した VPC を使用"
    type        = string
    default     = ""
}
