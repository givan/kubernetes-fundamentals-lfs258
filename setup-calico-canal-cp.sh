printf "Control plane IP: $(hostname -i) \n"

printf "# alias for k8s control plane:\n$(hostname -i) k8scp\n" | sudo tee -a /etc/hosts > /dev/null

echo "kubeadm version: $(kubeadm version)"

# create the K8s cluster
sudo kubeadm init --config=kubeadm-canal-config.yaml --upload-certs | tee kubeadm-init.out

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/tigera-operator.yaml

# install calico (security) with flannel CNI (canal) manifest
# reference: https://docs.tigera.io/calico/latest/getting-started/kubernetes/flannel/install-for-flannel
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/canal.yaml
