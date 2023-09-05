# setup cilium as per https://docs.cilium.io/en/latest/gettingstarted/k8s-install-default/

AZURE_RESOURCE_GROUP='george.ivanov-rg'

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