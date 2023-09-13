printf "Control plane IP: $(hostname -i) \n"

K8S_HAPROXY_IP = echo '10.2.0.7' # replace this with the IP of the HA proxy node that is before the CPs

printf "# alias for k8s control plane:\n$(K8S_HAPROXY_IP) k8scp\n" | sudo tee -a /etc/hosts > /dev/null

echo "kubeadm version: $(kubeadm version)"

# You can now join any number of the control-plane node running the following command on each as root:

#   kubeadm join k8scp:6443 --token s4lj41.tzc5ayvixfa7erv0 \
#         --discovery-token-ca-cert-hash sha256:31bb752676365ab2ab97a64c22614c8874e5cea633275fdab983703fb0f6f02e \
#         --control-plane --certificate-key 48db03f8af11d245e866e4c7f05ca3b56af2739c0a743b3cd62f1ceee8f311d5

# Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
# As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
# "kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

# sudo kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out

# on the existing CP node, run this command to get a new join token:
# kubeadm token create --print-join-command

kubeadm join k8scp:6443 \
    --control-plane \
    --token x1ewuf.wk2myob23me7rtrn \
    --discovery-token-ca-cert-hash sha256:31bb752676365ab2ab97a64c22614c8874e5cea633275fdab983703fb0f6f02e \
    --certificate-key e28915a01a7eff551beabfc7dddd09989a73ad829983e3a7f55203a4c9949af2


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# setup cilium as per https://docs.cilium.io/en/latest/gettingstarted/k8s-install-default/
AZURE_RESOURCE_GROUP='george.ivanov-rg' # TODO - replace - make this a env variable
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

git clone https://github.com/cilium/cilium
cd cilium

cilium install --chart-directory ./install/kubernetes/cilium --set azure.resourceGroup="${AZURE_RESOURCE_GROUP}"