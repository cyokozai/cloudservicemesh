# Cloud Servie Mesh セットアップ

- `mesh.yaml` ファイルを作成する
    
    ```bash
    echo "management: automatic" > mesh.yaml
    ```
    
- Cloud Service Mesh のフリート機能を有効にする
    
    ```bash
    gcloud container fleet mesh enable --project $FLEET_PROJECT_ID \
    	--fleet-default-member-config mesh.yaml
    ```
    
- クラスタの作成を行う
    
    ```bash
    gcloud container clusters create-auto $CLUSTER_PROJECT_ID \
    	--fleet-project=$FLEET_PROJECT_ID \
    	--location $REGION
    ```
    
- クラスタの作成が完了したら作成されたクラスタを確認する
    
    ```bash
    gcloud container clusters list
    ```
    
    - 結果  
    ※ NUM_NODES が空なのは Autopilot の仕様
        
        ```bash
        NAME                  LOCATION         MASTER_VERSION      MASTER_IP        MACHINE_TYPE  NODE_VERSION        NUM_NODES  STATUS
        <CLUSTER_PROJECT_ID>  asia-northeast1  1.32.4-gke.1106006  XXX.XXX.XXX.XXX  e2-small      1.32.4-gke.1106006             RUNNING
        ```
        
- `kubectl` が作成したクラスタを参照するようにクレデンシャルを取得する
    
    ```bash
    gcloud container clusters get-credentials $CLUSTER_PROJECT_ID \
      --location $REGION \
      --project $FLEET_PROJECT_ID
    ```
    
- クラスタの起動を確認
    
    ```bash
    kubectl config current-context
    ```
    
    - 結果
        
        ```bash
        gke_<FLEET_PROJECT_ID>_<REGION>_<CLUSTER_PROJECT_ID>
        ```
        
- 次のコマンドを実行してクラスタの [Workload Identity プール](https://cloud.google.com/iam/docs/workload-identity-federation?hl=ja#pools) を一覧取得し、Workload Identity 連携が有効になったことを確認する
    
    ```bash
    gcloud container clusters describe $CLUSTER_PROJECT_ID \
      --location $REGION \
      --format="value(workloadIdentityConfig.workloadPool)"
    ```
    
    - 以下の値が返ってくれば有効である
        
        ```bash
        <FLEET_PROJECT_ID>.svc.id.goog
        ```
        
- クラスタがフリートに登録されていることを確認
    
    ```bash
    gcloud container fleet memberships list --project $FLEET_PROJECT_ID
    ```
    
    - 確認
        
        ```bash
        NAME                  UNIQUE_ID                             LOCATION
        <CLUSTER_PROJECT_ID>  00000000-0000-0000-0000-000000000000  <REGION>
        ```
        
- Cluster の Mesh API を有効化
    
    ```bash
    gcloud services enable mesh.googleapis.com --project $FLEET_PROJECT_ID
    ```
    
- ローカルからコントロールプレーンがプロビジョニングされていることを確認する
    
    ```bash
    gcloud container fleet mesh describe --project $FLEET_PROJECT_ID
    ```
    
    - 以下のような出力が表示される
        
        ```yaml
        ~~~
        membershipSpecs:
          projects/000000000000/locations/asia-northeast1/memberships/yinoue-csm-bookinfo:
            mesh:
              management: MANAGEMENT_AUTOMATIC
            origin:
              type: FLEET
        membershipStates:
          projects/000000000000/locations/asia-northeast1/memberships/yinoue-csm-bookinfo:
            servicemesh:
        ~~~
              controlPlaneManagement:
                details:
                - code: REVISION_READY
                  details: 'Ready: asm-managed'
                implementation: TRAFFIC_DIRECTOR
                state: ACTIVE
              dataPlaneManagement:
                details:
                - code: OK
                  details: Service is running.
                state: ACTIVE
            state:
              code: OK
              description: 'Revision ready for use: asm-managed.'
        ~~~
        ```
        
- Web コンソールを開き、クラスタから `$CLUSTER_PROJECT_ID` を選択し、機能欄の一番下の項目を確認する  
「プロビジョニング済み」とあれば成功

# Istio Ingress Gateway のインストール

- 以下のコマンドで `istio-system` Namespace を作成
    
    ```bash
    kubectl apply -f - <<EOF
    apiVersion: v1
    kind: Namespace
    metadata:
      name: istio-system
      annotations:
        mesh.cloud.google.com/proxy: '{"managed":"true"}'
      labels:
        istio-injection: enabled
    EOF
    ```
    
- [anthos-service-mesh-packages](https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git) リポジトリをクローンする
    
    ```bash
    git clone https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git
    ```
    
- `istio-system` Namespace に `istio-ingressgateway` をデプロイする
    
    ```bash
    kubectl apply -n istio-system -f ./anthos-service-mesh-packages/samples/gateways/istio-ingressgateway
    ```
    
- Service に `EXTERNAL-IP` が割り振られているか確認
    
    ```bash
    kubectl get svc -n istio-system
    ```
    
    - 結果
        
        ```bash
        NAME                   TYPE           CLUSTER-IP        EXTERNAL-IP       PORT(S)                                      AGE
        istio-ingressgateway   LoadBalancer   XXX.XXX.XXX.XXX   XXX.XXX.XXX.XXX   15021:30242/TCP,80:32325/TCP,443:31116/TCP   12m
        ```
        
- Pod に `istio=ingressgateway` ラベルがあるかを確認
    
    ```bash
    kubectl get pod -n istio-system -l istio=ingressgateway --show-labels | grep "istio=ingressgateway"
    ```
    
    - 結果
        
        ```bash
        istio-ingressgateway-8467899995-dhn7k   1/1     Running   0          35m    app=istio-ingressgateway,istio=ingressgateway,pod-template-hash=8467899995,service.istio.io/canonical-name=istio-ingressgateway,service.istio.io/canonical-revision=latest
        istio-ingressgateway-8467899995-pjbkn   1/1     Running   0          35m    app=istio-ingressgateway,istio=ingressgateway,pod-template-hash=8467899995,service.istio.io/canonical-name=istio-ingressgateway,service.istio.io/canonical-revision=latest
        istio-ingressgateway-8467899995-sdffs   1/1     Running   0          35m    app=istio-ingressgateway,istio=ingressgateway,pod-template-hash=8467899995,service.istio.io/canonical-name=istio-ingressgateway,service.istio.io/canonical-revision=latest
        ```
