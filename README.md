# mlops-platform

# Dev
Deploy chart manualy:
```
kubectl kustomize . --enable-helm | kubectl apply  -f -
```

method 1 - expose dashboard svc
```
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard 8001:443
```
available at https://localhost:8001/

method 2 - expose ingress
expose 
```
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8001:443
```
available later at https://dashboard.localhost:8001/
then
```
local pc:
ssh -L localhost:8001:localhost:8001 mde@192.168.2.150
```
then
```
kubectl -n kubernetes-dashboard create token admin-user
```

```
kubeseal --scope namespace-wide --controller-name sealed-secrets --controller-namespace=sealed-secrets -f secret.yaml -w sealed-secret.yaml -n ods

```