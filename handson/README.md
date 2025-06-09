# Argo Rollouts Demo ApplicationAdd commentMore actions

- Create `handson` namespace

```shell
kubectl create namespace handson
```

```shell
kubectl apply -f manifest/blue/serviceaccount.yaml -n handson
kubectl apply -f manifest/blue/deployment.yaml -n handson
kubectl apply -f manifest/base/service.yaml -n handson
kubectl apply -f manifest/base/ingress.yaml -n handson
```

or  

```shell
kustomize build ./manifest/base | kubectl apply -f - 
```

```shell
kubectl get services,deployments,ingresses -n handson
```

```shell
APP_HOST=$(kubectl get ingress app-ingress-by-gke-csm -n handson -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo $APP_HOST
```

```shell
gcloud dns --project=$PROJECT_ID record-sets create "csm.${DNS_SUFFIX}." \
    --zone=$CLOUD_DNS_ID \
    --type="A" \
    --ttl="300" \
    --rrdatas=$APP_HOST
```

```shell
kubectl delete -f manifest/base/serviceaccount.yaml -n handson -l color=blue
kubectl delete -f manifest/base/deployment.yaml -n handson -l color=blue
kubectl delete -f manifest/base/service.yaml -n handson
kubectl delete -f manifest/base/ingress.yaml -n handson
```

or  

```shell
kustomize build ./manifest/base | kubectl delete -f - 
```