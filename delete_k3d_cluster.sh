source .env
echo "Deleting cluster $CLUSTER_NAME"
k3d cluster delete $CLUSTER_NAME