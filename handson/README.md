# Argo Rollouts Demo ApplicationAdd commentMore actions

- `cd handson`
- Create `handson` namespace

```shell
kubectl create namespace handson
```

- `cd cnd-handson/chapter_cluster-create`
- Deploy the application

```shell
kubectl apply -f manifest/app/serviceaccount.yaml -n handson -l color=blue
kubectl apply -f manifest/app/deployment.yaml -n handson -l color=blue
kubectl apply -f manifest/app/service.yaml -n handson
kubectl apply -f manifest/app/ingress.yaml -n handson
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
kubectl delete -f manifest/app/serviceaccount.yaml -n handson -l color=blue
kubectl delete -f manifest/app/deployment.yaml -n handson -l color=blue
kubectl delete -f manifest/app/service.yaml -n handson
kubectl delete -f manifest/app/ingress.yaml -n handson
```
