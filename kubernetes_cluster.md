## Install Docker 20.10

curl https://releases.rancher.com/install-docker/20.10.sh | sh


cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "dns": ["172.20.5.160"]
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker

sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="cgroup_enable=memory cgroup_memory=1 systemd.unified_cgroup_hierarchy=0"/' /etc/default/grub
update-grub && reboot

For Rancher 1.6.x

docker run -d --restart=unless-stopped \
	-p 80:80 -p 443:443 \
	--privileged \
	rancher/server:stable

For Rancher 2 
docker run -d --restart=unless-stopped \
  	-p 80:80 -p 443:443 --privileged  \
	rancher/rancher:latest

To discover password for Rancher 2:
docker logs `docker container ls | grep rancher | awk '{ print $1 }'`  2>&1 | grep "Bootstrap Password:"



cat > /etc/sysctl.d/10-k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl -p


cat > /etc/modules-load.d/k8s.conf << EOF
br_netfilter
ip_vs
ip_vs_rr
ip_vs_sh
ip_vs_wrr
nf_conntrack_ipv4
EOF


sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt install -y kubectl=1.24.11-00 kubeadm=1.24.11-00 kubelet=1.24.11-00
sudo apt-mark hold kubelet kubectl kubeadm

containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml  
service containerd restart
service kubelet restart  


mkdir -p /run/flannel
cat > /run/flannel/subnet.env << EOF
	FLANNEL_NETWORK=10.240.0.0/16
	FLANNEL_SUBNET=10.240.0.1/24
	FLANNEL_MTU=1450
	FLANNEL_IPMASQ=true
EOF

kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=172.20.5.101:6443 --apiserver-advertise-address=172.20.5.101 --node-name teste-gorayeb-master1 --upload-certsteste-gorayeb-worker1


kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

kubectl label node teste-gorayeb kubernetes.io/role=master
kubectl label node teste-gorayeb2 kubernetes.io/role=worker


sudo kubeadm reset
sudo systemctl enable docker
sudo systemctl enable kubelet
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo rm -rf /etc/kubernetes/kubelet.conf /etc/kubernetes/pki/ca.crt



curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm -y


helm repo add jetstack https://charts.jetstack.io
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm install cert-manager jetstack/cert-manager   --namespace cert-manager   --create-namespace   --version v1.7.1
kubectl create namespace cattle-system
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.crds.yaml
kubectl get pods -n cert-manager
helm pull rancher rancher-stable/rancher
helm upgrade --install rancher /tmp/rancher/   --namespace cattle-system   --set hostname=rancher.mn.sipam.gov.br   --set replicas=1 

kubeadm reset --force
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/*
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/*
rm -rf /etc/kubernetes/ /var/lib/etcd
systemctl start kubelet
systemctl start docker

### Taint/Untaint Nodes
kubectl describe node teste-gorayeb-master1 | grep Taints
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule
