```
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/cloud/deploy.yaml > deploy.yaml
kubectl apply -f deploy.yaml -n ingress-nginx
kubectl -n ingress-nginx get pods

```