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
kubectl delete -f istio-1.*/samples/bookinfo/networking/bookinfo-gateway.yaml
```

- Set istio variables

```bash
export INGRESS_NAME=istio-ingressgateway
export INGRESS_NS=istio-system
```

- Confirm `istio-ingressgateway`

```bash
kubectl get svc "$INGRESS_NAME" -n "$INGRESS_NS"
```

- [Access](http://${EXTERNAL_IP}/productpage)

130.211.25.158