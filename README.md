# Deployment
### Create .env
eg:
```
CLUSTER_NAME="mlops-platform"
NUM_WORKERS=1
VOLUME_PATH_AGENT_0=$(pwd)/volume
```
### Run k3d cluster

```
./create_k3d_cluster.sh
```
### Run argocd
```
kubectl apply -k argocd/overlays/test/
```
May throw errors related to cert-manager

### Run argoapps
```
kubectl apply -k argo-apps/overlays/test/
```
wait till essential apps(argocd, argo-apps, ingress-nginx, cert-manager, sealed-secrets) are `Healthy`:
```
watch kubectl get applications -A
```

### Forward nginx-ingress
```
kubectl -n ingress-nginx --address 0.0.0.0 port-forward svc/ingress-nginx-controller 11443:443
```
access apps on *.localhost eg:
- argocd.localhost
- dashboard.localhost
- mlflow.localhost
When cluster is on remote server, portforward servers localhost to local-workstation's localhost:
run on local-workstation:
```
ssh -L localhost:11443:localhost:11443 mde@192.168.2.150
```

### Get argo webui password
- go to argocd.localhost
- username is admin
- password:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Kubernetes dashboard
- go to dashboard.localhost
- create access token:
```
./kubernetes-dashboard/overlays/test/get-token.sh 
```
or directly:
```
kubectl -n kubernetes-dashboard create token admin-user
```
- put the token to login form
- you can find password to other apps in the dashboard

# Deleting cluster
```
./delete_k3d_cluster.sh
```
# Helpers

### kustomization/helmcharts
deploying helm-chart using kustimize:
```
kubectl kustomize . --enable-helm | kubectl apply  -f -
```
### creating sealed secrets:
install kubeseal cli:
```
./install_kubeseal.sh
```
```
kubeseal --scope namespace-wide --controller-name sealed-secrets --controller-namespace=sealed-secrets -f secret.yaml -w sealed-secret.yaml -n <namespace>
```

# Updating secrets
example for mlflow
```
kubectl delete sealedsecrets.bitnami.com -n mlflow --all
```
generate new secets:
```
kubeseal --scope namespace-wide --controller-name sealed-secrets --controller-namespace=sealed-secrets -f secret.yaml -w sealed-secret.yaml -n mlflow
```
then git add them, push, refresh argo app

