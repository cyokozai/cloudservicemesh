# Argo Rollouts Demo Application

- Create `handson` namespace

```shell
kubectl create namespace handson
```

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
kubectl delete -f manifest/app/serviceaccount.yaml -n handson -l color=blue
kubectl delete -f manifest/app/deployment.yaml -n handson -l color=blue
kubectl delete -f manifest/app/service.yaml -n handson
kubectl delete -f manifest/app/ingress.yaml -n handson
```
