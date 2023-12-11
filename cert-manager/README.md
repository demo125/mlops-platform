```
curl -LO https://github.com/jetstack/cert-manager/releases/download/v1.13.2/cert-manager.yaml
kubectl apply --validate=false -f cert-manager.yaml
```