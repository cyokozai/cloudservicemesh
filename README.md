# Cloud Service Mesh / Istio

- Istio Hands-on with CND implemented with Cloud Service Mesh  

## Setup

### Kubernetes clusterの作成  

- Setup Google Cloud CLI

```bash
gcloud auth login --project FLEET_PROJECT_ID
gcloud components update
gke-gcloud-auth-plugin --version
gcloud components install gke-gcloud-auth-plugin
gke-gcloud-auth-plugin --version
```

- `FLEET_PROJECT_ID`を調べる

```bash
gcloud projects list
gcloud config set project FLEET_PROJECT_ID
```

```bash
$ gcloud projects list
PROJECT_ID        NAME              PROJECT_NUMBER
FLEET_PROJECT_ID  FLEET_PROJECT_ID  XXXXXXXXXXXX
```

- `FLEET_PROJECT_NUMBER`を調べる

```bash
gcloud projects describe FLEET_PROJECT_ID --format="value(projectNumber)"
```

```bash
curl https://storage.googleapis.com/csm-artifacts/asm/asmcli > asmcli  
chmod +x asmcli  
```

- install istio

```bash
brew install istioctl
istioctl version
```

- set namespase

```bash
kubectl label namespace default istio-injection=enabled  
```

---

20240924

## GKE でマネージド Cloud Service Mesh コントロール プレーンをプロビジョニングする

- フリート ホスト プロジェクトで必要な API を有効にする

```bash
gcloud services enable mesh.googleapis.com --project=FLEET_PROJECT_ID
```

### マネージド Cloud Service Mesh を構成する

- `management: automatic` を 1 行のみ含む `mesh.yaml` ファイルを作成

```bash
echo "management: automatic" > mesh.yaml
```

- `anthos.googleapis.com`サービスを有効にする
  - [参考](https://cloud.google.com/kubernetes-engine/docs/how-to/enable-gkee?hl=ja)

```bash
gcloud services enable anthos.googleapis.com --project=FLEET_PROJECT_ID
```

- フリートで Cloud Service Mesh を有効にする

```bash
gcloud container fleet mesh enable --project FLEET_PROJECT_ID \
    --fleet-default-member-config mesh.yaml
```

- `NETWORK_PROJECT_ID`は`yinoue-csm-vpc`を作成

```bash
gcloud compute networks create yinoue-csm-vpc --subnet-mode=auto --bgp-routing-mode=REGIONAL
```

```bash
gcloud compute networks list --project=FLEET_PROJECT_ID
```

- Firewallを設定しろと言われた

```bash
gcloud compute firewall-rules create yinoue-fw --network yinoue-csm-vpc --allow tcp:22,tcp:3389,icmp
gcloud compute firewall-rules create yinoue-fw --network yinoue-csm-vpc --allow tcp,udp,icmp --source-ranges <IP_RANGE>
```

- ネットワークレベルの設定

ネットワークのプロジェクトがフリート ホスト プロジェクトと異なる場合（共有 VPC を使用している場合など）、フリート プロジェクトの Cloud Service Mesh サービス アカウントにネットワーク プロジェクトへのアクセスを許可する必要があります。この手順は、ネットワーク プロジェクトに対して 1 回だけ行う必要があります。  
フリート プロジェクトのサービス アカウントに、ネットワーク プロジェクトにアクセスするための権限を付与します。  

```bash
gcloud projects add-iam-policy-binding "FLEET_PROJECT_ID"  \
    --member "serviceAccount:service-FLEET_PROJECT_NUMBER@gcp-sa-servicemesh.iam.gserviceaccount.com" \
    --role roles/anthosservicemesh.serviceAgent
```

- クラスタのプロジェクトがフリート ホスト プロジェクトと異なる場合は、フリート プロジェクトの Cloud Service Mesh サービス アカウントにクラスタ プロジェクトへのアクセスを許可し、クラスタ プロジェクトで必要な API を有効にする必要があります。この手順は、クラスタ プロジェクトごとに 1 回だけ行う必要があります。

フリート プロジェクトのサービス アカウントに、クラスタ プロジェクトにアクセスするための権限を付与します。

```bash
gcloud projects add-iam-policy-binding "FLEET_PROJECT_ID"  \
    --member "serviceAccount:service-FLEET_PROJECT_NUMBER@gcp-sa-servicemesh.iam.gserviceaccount.com" \
    --role roles/anthosservicemesh.serviceAgent
```

- ClusterのMesh API を有効化

```bash
gcloud services enable mesh.googleapis.com \
  --project=yinoue-istio2csm
```

- Cloud Service Mesh のフリート機能を有効にする

```bash
gcloud container fleet mesh enable --project FLEET_PROJECT_ID
```

---

- クラスタをフリートに登録する

```bash
gcloud container clusters update yinoue-istio2csm  \
  --location asia-northeast1 \
  --fleet-project FLEET_PROJECT_ID
```

- 確認

```bash
gcloud container fleet memberships list --project FLEET_PROJECT_ID
```

- create cluster in Auto-pilot

```bash
gcloud container clusters create yinoue-istio2csm --region=asia-northeast1  
gcloud container clusters create yinoue-istio2csm --num-nodes 2 --enable-ip-alias --create-subnetwork="" --network=default --labels=team=intern --zone=asia-northeast1-a
```

- コントロール プレーンがプロビジョニングされていることを確認する

```bash
gcloud container fleet mesh describe --project sreake-intern
```

- クラスタを参照するように kubectl を構成

```bash
gcloud container clusters get-credentials yinoue-istio2csm \
      --region=asia-northeast1 \
      --project sreake-intern
```

> Ingress ゲートウェイはコントロール プレーンで自動的にはデプロイされないことに注意してください。Ingress ゲートウェイとコントロール プレーンのデプロイを分離すると、本番環境でゲートウェイを管理できます。Istio Ingress ゲートウェイまたは Egress ゲートウェイを使用する場合は、ゲートウェイをデプロイするをご覧ください。Kubernetes Gateway API を使用する場合は、Mesh 用ゲートウェイを準備するをご覧ください。他のオプション機能を有効にするには、Cloud Service Mesh でオプション機能を有効にするをご覧ください。

