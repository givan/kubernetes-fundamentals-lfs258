sudo apt-get update && sudo apt-get install -y nfs-kernel-server

sudo mkdir /opt/sfw
sudo chmod 1777 /opt/sfw/

sudo bash -c 'echo software > /opt/sfw/hello.txt'

printf "\n/opt/sfw/ *(rw,sync,no_root_squash,subtree_check)\n" | sudo tee -a /etc/exports > /dev/null

sudo exportfs -ra