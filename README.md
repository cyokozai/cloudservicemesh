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
gcloud config set project FLEET_PROJECT_ID
gcloud projects list
PROJECT_ID     NAME           PROJECT_NUMBER
FLEET_PROJECT_ID  FLEET_PROJECT_ID  XXXXXXXXXXXX
```

- `FLEET_PROJECT_NUMBER`を調べる

```bash
$ gcloud projects describe FLEET_PROJECT_ID --format="value(projectNumber)"
```

- create clueter in Auto-pilot

```bash
gcloud container clusters create yinoue-istio2csm  
gcloud container clusters create yinoue-istio2csm --num-nodes 2 --enable-ip-alias --create-subnetwork="" --network=default --labels=team=intern --zone=asia-northeast1-a
gcloud container clusters get-credentials yinoue-istio2csm --region=asia-northeast1
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
$ gcloud compute networks list --project=FLEET_PROJECT_ID
yinoue-csm-vpc               AUTO         REGIONAL
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

```bash
$ gcloud container clusters update yinoue-istio2csm  \
  --location asia-northeast1 \
  --fleet-project FLEET_PROJECT_ID
Updating yinoue-istio2csm...done.                                                                                                                                                                
Updated [https://container.googleapis.com/v1/projects/FLEET_PROJECT_ID/zones/asia-northeast1/clusters/yinoue-istio2csm].
To inspect the contents of your cluster, go to: https://console.cloud.google.com/kubernetes/workload_/gcloud/asia-northeast1/yinoue-istio2csm?project=FLEET_PROJECT_ID
```

- 確認

```bash
$ gcloud container fleet memberships list --project FLEET_PROJECT_ID
NAME              UNIQUE_ID                             LOCATION
yinoue-istio2csm  cceae56f-6b3d-41dc-8e08-8561ca1cdf5d  asia-northeast1
```

```bash
$ gcloud container fleet mesh describe --project sreake-intern
createTime: '2024-08-21T05:59:54.307241918Z'
membershipStates:
  projects/250069194041/locations/asia-northeast1/memberships/yinoue-istio2csm:
    servicemesh:
      controlPlaneManagement:
        details:
        - code: DISABLED
          details: Control Plane Management is not enabled.
        state: DISABLED
      dataPlaneManagement:
        details:
        - code: DISABLED
          details: Data Plane Management is not enabled.
        state: DISABLED
    state:
      description: Please see https://cloud.google.com/service-mesh/docs/install for
        instructions to onboard to Anthos Service Mesh.
      updateTime: '2024-09-26T06:06:15.548387591Z'
name: projects/sreake-intern/locations/global/features/servicemesh
resourceState:
  state: ACTIVE
spec: {}
updateTime: '2024-08-26T07:49:47.369464272Z'
```
