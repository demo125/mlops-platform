#https://hub.docker.com/_/ubuntu
FROM ubuntu:22.04
RUN apt-get update -y
RUN apt-get install ca-certificates curl gnupg -y
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg

#https://docs.docker.com/engine/install/ubuntu/
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "xenial") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y
RUN apt-get install docker-ce docker-ce-cli -y
RUN apt-get install wget -y
RUN cp /usr/bin/docker /var/lib/

#https://github.com/Mirantis/cri-dockerd
RUN wget -qO- https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd-0.3.9.amd64.tgz | tar xvz -C .
RUN mv cri-dockerd/cri-dockerd /bin

#https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
RUN apt-get install -y apt-transport-https ca-certificates curl gpg
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update -y
RUN apt-get install -y kubelet kubeadm kubectl
RUN apt-mark hold kubelet kubeadm kubectl

#[ERROR SystemVerification]: failed to parse kernel config: unable to load kernel module: "configs", output: "modprobe: FATAL: Module configs not found in directory /lib/modules/5.15.0-91-generic\n", err: exit status 1
#https://github.com/kubernetes/kubernetes/issues/41025
RUN apt-get install linux-image-$(uname -r) -y
RUN apt-get install systemctl nano -y

ADD config /root/.kube/config
ENV KUBECONFIG /root/.kube/config
RUN apt-get install containerd -y
RUN echo "" > /etc/containerd/config.toml
RUN systemctl enable kubelet
# docker run -it  -v /var/run/docker.sock:/var/run/docker.sock -v /var/run/containerd/containerd.sock:/run/containerd/containerd.sock --network=host --name dind --rm dind bash

# docker run -it  -v /dev/kmsg:/dev/kmsg --name dind --privileged --rm dind bash
# systemctl restart containerd
# kubelet --fail-swap-on=false

#cri-dockerd
# docker exec
# curl https://10.201.50.246:40063/api/v1/namespaces -H 'Authorization: Bearer o434r2.fnnkn52ajun7sq5w' --insecure
#kubeadm token create --print-join-command
# kubeadm join 10.201.50.246:40063 --token o434r2.fnnkn52ajun7sq5w --discovery-token-ca-cert-hash sha256:0c84abc622a8cce4e5f42637787f438405053eb7f8b6859e170343c49d7c6695 


# curl https://10.201.50.246:40063/api/v1/namespaces/kube-public/configmaps/cluster-info -H 'Authorization: Bearer o434r2.fnnkn52ajun7sq5w' --insecure



# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRole
# metadata:
#   name: namespace-reader
# rules:
# - apiGroups: [""]
#   resources: ["pods","services","namespaces","deployments","jobs", "configmaps"]
#   verbs: ["get","list","watch"]
# ---
# apiVersion: rbac.authorization.k8s.io/v1
# kind: ClusterRoleBinding
# metadata:
#   name: bind-namespace-reader
# subjects:
# - kind: User
#   name: system:bootstrap:o434r2
#   apiGroup: rbac.authorization.k8s.io
# roleRef:
#   kind: ClusterRole
#   name: namespace-reader
#   apiGroup: rbac.authorization.k8s.io
# ---
# kind: ConfigMap
# apiVersion: v1
# metadata:
#   name: cluster-info
#   namespace: kube-public
# data:
#   my-data: "qwe"