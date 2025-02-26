# Install Istio

- Download Istio

```bash
curl -L https://istio.io/downloadIstio | sh -
```

- Install Istio CRDs

```bash
kubectl apply -f istio-1.*.*/manifests/charts/base/templates/crds.yaml
```

- Apply Bookinfo Gateway

```bash
kubectl apply -f ./istio-1.*/samples/bookinfo/networking/bookinfo-gateway.yaml
```

- [Access](http://${EXTERNAL_IP}/productpage)
