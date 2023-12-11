source .env

mkdir volume

mkdir $VOLUME_PATH_AGENT_0/minio -p
mkdir $VOLUME_PATH_AGENT_0/mlflow/postgres -p
mkdir $VOLUME_PATH_AGENT_0/mlflow/minio -p
mkdir $VOLUME_PATH_AGENT_0/docker-registry -p

chgrp 1001 volume  -R
ls -l volume
