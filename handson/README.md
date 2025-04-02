# Argo Rollouts Demo Application

```shell
gcloud container clusters create-auto $CLUSTER_PROJECT_ID \
	--additive-vpc-scope-dns-domain $UNIQUE_CLUSTER_DOMAIN \
	--fleet-project $FLEET_PROJECT_ID \
    --network $NETWORK_PROJECT_ID \
	--location $REGION \
    --release-channel=rapid \
	--labels=team=intern
```

```shell
gcloud dns managed-zones create $CLOUD_DNS_ID \
    --description $DESCRIPTION \
    --dns-name $DNS_SUFFIX \
    --visibility "public" \
    --labels=team=intern
```

```shell

```

- Create `handson` namespace

```shell
kubectl create namespace handson
```

```shell
kubectl apply -f manifest/base/serviceaccount.yaml -n handson -l color=blue
kubectl apply -f manifest/base/deployment.yaml -n handson -l color=blue
kubectl apply -f manifest/base/service.yaml -n handson
kubectl apply -f manifest/base/ingress.yaml -n handson
```

```shell
kubectl get services,deployments,ingresses -n handson
```

```shell
kubectl delete -f manifest/base/serviceaccount.yaml -n handson -l color=blue
kubectl delete -f manifest/base/deployment.yaml -n handson -l color=blue
kubectl delete -f manifest/base/service.yaml -n handson
kubectl delete -f manifest/base/ingress.yaml -n handson
```
