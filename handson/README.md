# Argo Rollouts Demo Application

- 

```shell
kubectl create namespace handson
```

- 

```shell
kubectl apply -f manifest/app/serviceaccount.yaml -n handson -l color=blue
kubectl apply -f manifest/app/deployment.yaml -n handson -l color=blue
kubectl apply -f manifest/app/service.yaml -n handson
kubectl apply -f manifest/app/ingress.yaml -n handson
```
