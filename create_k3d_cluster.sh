#!/bin/bash

#to read .env variables
source .env

# Check if k3d is installed
if ! command -v k3d &> /dev/null; then
    echo "k3d is not installed. Please install it first."
    exit 1
fi


echo "Creating volume from $VOLUME_PATH_AGENT_0"
./create_data_folders.sh


echo "Creating cluster $CLUSTER_NAME with $NUM_WORKERS workers"
# Create k3d cluster
#params: check .env file
k3d cluster create "$CLUSTER_NAME" \
--agents "$NUM_WORKERS" \
-p "10443:443@agent:0" \
-p "10080:80@agent:0" \
--volume $VOLUME_PATH_AGENT_0:/volume-data@agent:0

kubectl config use-context $CLUSTER_NAME

kubectl create namespace $namespace

# Verify the cluster
kubectl get nodes