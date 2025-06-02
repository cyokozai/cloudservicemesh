# テストアプリ Bookinfo のインストール

![https://istio.io/latest/docs/examples/bookinfo/withistio.svg](https://istio.io/latest/docs/examples/bookinfo/withistio.svg)

- デフォルトのインジェクション ラベルを Namespace に適用する
    
    ```bash
    kubectl label namespace default istio.io/rev- istio-injection=enabled --overwrite
    ```
    
- `istio-injection` ラベルがついた Namespace を確認
    
    ```bash
    kubectl get ns --show-labels | grep "istio-injection"
    ```
    
    - 結果
        
        ```bash
        default                        Active   32m   istio-injection=enabled,kubernetes.io/metadata.name=default
        istio-system                   Active   13m   istio-injection=enabled,kubernetes.io/metadata.name=istio-system
        ```
        
- 最新版の Istio をローカルのワーキングディレクトリにダウンロードする
※ バージョンを指定する場合は `ISTIO_VERSION=<version number> sh -` と記述する
    
    ```bash
    curl -L https://istio.io/downloadIstio | sh -
    ```
    
- 以下のコマンドを実行して Bookinfo アプリをデプロイする
    
    ```bash
    kubectl apply -f ./istio-1.26.0/samples/bookinfo/platform/kube/bookinfo.yaml
    ```
    
- アプリケーションがデプロイできたか確認する
    
    ```bash
    kubectl get pods,services
    ```
    
    - 結果
        
        ```bash
        NAME                                  READY   STATUS    RESTARTS   AGE
        pod/details-v1-84766dc95b-k6h2h       2/2     Running   0          53s
        pod/productpage-v1-77549cbd67-bmlgk   2/2     Running   0          50s
        pod/ratings-v1-b68c7d664-n9xdq        2/2     Running   0          53s
        pod/reviews-v1-cd8d4db96-7rhdv        2/2     Running   0          52s
        pod/reviews-v2-759fd6876d-8bq9h       2/2     Running   0          51s
        pod/reviews-v3-f98496d4-d6mdn         2/2     Running   0          51s
        
        NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
        service/details       ClusterIP   34.118.227.159   <none>        9080/TCP   55s
        service/kubernetes    ClusterIP   34.118.224.1     <none>        443/TCP    35m
        service/productpage   ClusterIP   34.118.235.96    <none>        9080/TCP   51s
        service/ratings       ClusterIP   34.118.237.113   <none>        9080/TCP   55s
        service/reviews       ClusterIP   34.118.230.239   <none>        9080/TCP   53s
        ```
        
- ClusterIP の DNS 解決とサービスメッシュ通信が成功しているかを Ratings Pod から確認
    
    ```bash
    kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
    ```
    
    - 結果
        
        ```html
        <title>Simple Bookstore App</title>
        ```
        
- `bookinfo-gateway.yaml` に以下の変更を加える
    - `apiVersion` を `v1` から `v1beta1` に変更
    - `metadata.namespace.default` を追加
    - `bookinfo-gateway.yaml`
        
        ```yaml
        apiVersion: networking.istio.io/v1beta1 # <- v1 から v1beta1 へ変更
        kind: Gateway
        metadata:
          name: bookinfo-gateway
          namespace: default # <- default Namespace を追加
        spec:
        ~~~
          servers:
          - port:
              number: 80 # <- 8080 から 80 へ変更
        ~~~
        ---
        apiVersion: networking.istio.io/v1beta1 # <- v1 から v1beta1 へ変更
        kind: VirtualService
        metadata:
          name: bookinfo
          namespace: default # <- default Namespace を追加
        ~~~
        ```
        
- Bookinfo のゲートウェイをデプロイする
    
    ```bash
    kubectl apply -f ./istio-1.26.0/samples/bookinfo/networking/bookinfo-gateway.yaml
    ```
    
- GKE Gatewayの確認
    
    ```bash
    kubectl get gw,virtualservice
    ```
    
    - 結果
        
        ```bash
        NAME                                           AGE
        gateway.networking.istio.io/bookinfo-gateway   60s
        
        NAME                                          GATEWAYS               HOSTS   AGE
        virtualservice.networking.istio.io/bookinfo   ["bookinfo-gateway"]   ["*"]   60s
        ```
        
- ゲートウェイの外部 IP アドレスを以下のコマンドを実行して取得する
    
    ```bash
    kubectl get svc -n istio-system
    ```
    
    - 結果
        
        ```bash
        NAME                   TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                                      AGE
        istio-ingressgateway   LoadBalancer   34.118.232.215   104.198.114.17   15021:32620/TCP,80:32461/TCP,443:32287/TCP   11m
        ```
