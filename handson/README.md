# Argo Rollouts Demo Application

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
