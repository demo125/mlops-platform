# TODO
- configure dagster-postgres pv to use nfs
- add etl images to local docker registry
- volumes for dagster apps are changing with every restart

# Important: Node selector
Label nodes on which can dagster spawn etl runs(check values.yaml runLauncher.k8sRunLauncher.runK8sConfig.podSpecConfig)
```
kubectl label nodes k3d-mlops-platform-agent-0  dagster-role=worker
```
# Kubeseal on windows
run Install-Kubeseal.ps1 a as script or copy and paste its content to the power shell terminal

https://github.com/jordan-owen/kubeseal-windows-installer

```
kubeseal --scope namespace-wide --controller-name sealed-secrets --controller-namespace=sealed-secrets -f secret.yaml -w sealed-secret.yaml -n ods
```

# Dashboard
get admin token:
```
kubectl -n kubernetes-dashboard create token admin-user
```

# Dev
Deploy chart manualy:
```
kubectl kustomize . --enable-helm | kubectl apply  -f -
```

# Dev docker registry 
All images should be pushed to kluster's docker registy to ensure availability.
Just for dev:
```
kubectl create secret docker-registry mindit-docker-registry-secret \
--docker-server=https://docker.mindit.sk:30000 \
--docker-username=veolia-amr \
--docker-password=$docker_registry_password \
--namespace ods
```

# misc
test db con:
```
psql -d "postgresql://testuser:pass@dagster-postgresql/testdb" -c "select now()"
```
