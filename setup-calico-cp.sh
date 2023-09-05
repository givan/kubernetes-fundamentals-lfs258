printf "Control plane IP: $(hostname -i) \n"

printf "# alias for k8s control plane:\n$(hostname -i) k8scp\n" | sudo tee -a /etc/hosts > /dev/null

# download calico with flannel CNI (canal) manifest
# wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/canal.yaml

echo "kubeadm version: $(kubeadm version)"

# create the K8s cluster
sudo kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# setup calico using tiger operator from https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml

# the following config manifest was originally modified from: https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/custom-resources.yaml
# as I'm enabling Calico CNI on Azure, Azure has issue with VXLAN cross subnet: see https://github.com/projectcalico/calico/issues/6568
# hence need to set the encap mode to VXLAN only
kubectl create -f calico-custom-resources.yaml

# another way is to setup Flannel (canal) using tiger operator from https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart

# Calico troubleshooting commands: https://docs.tigera.io/calico/latest/operations/troubleshoot/commands#routing

