# install kubectl bash completion
sudo apt-get install bash-completion -y
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> $HOME/.bashrc
echo "alias k='kubectl'" >> $HOME/.bashrc
echo "alias do='--dry-run=client --o yaml'" >> $HOME/.bashrc

