#!/bin/bash

#to read .env variables
source .env

# Check if k3d is installed
if ! command -v k3d &> /dev/null; then
    echo "k3d is not installed. Please install it first."
    exit 1
fi


echo "Creating volume folders"
./create_data_folders.sh


echo "Creating cluster "mlops-platform" with "1" workers"
# Create k3d cluster
#params: check .env file

k3d cluster create $CLUSTER_NAME --agents $NUM_WORKERS --config ./k3d-config.yaml

# k3d cluster create "$CLUSTER_NAME" \
# --agents "$NUM_WORKERS" \
# -p "10443:443@agent:0" \
# -p "10080:80@agent:0" \
# --volume $VOLUME_PATH_AGENT_0:/volume-data@agent:0 \
# --volume "$(pwd)/registry-ca.pem:/etc/ssl/certs/registry-ca.pem" \
# --registry-config ./registries.yaml

kubectl config use-context $CLUSTER_NAME

# Taint the master node, so pods will not be scheduled on it
kubectl taint nodes k3d-mlops-platform-server-0 node-role.kubernetes.io/master=:NoSchedule
# label a node as a dagster worker
# check dagster/base/values.yaml runLauncher.config.k8sRunLauncher.runK8sConfig.podSpecConfig.nodeSelector
kubectl label nodes k3d-mlops-platform-agent-0  dagster-role=worker

# Verify the cluster
kubectl get nodes

kubectl apply -f ./sealed-secrets/overlays/test/sealed-secrets-bootstrap.yaml -n sealed-secrets
kubectl apply -k argocd/overlays/test/
kubectl apply -k argo-apps/overlays/test/
cd loki/base/crds && bash ./up.sh
