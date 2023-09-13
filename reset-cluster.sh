sudo kubeadm reset -f

sudo rm -f /etc/cni/net.d/*.conflist
sudo rm -f /etc/cni/net.d/*-kubeconfig

sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
sudo ipvsadm --clear

rm -rf ~/.kube