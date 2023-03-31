## For Rancher 1.6.x
docker run -d --restart=unless-stopped \
	-p 80:80 -p 443:443 \
	--privileged \
	rancher/server:stable

## For Rancher 2 
docker run -d --restart=unless-stopped \
  	-p 80:80 -p 443:443 --privileged  \
	rancher/rancher:latest

## To discover password for Rancher 2:
        docker logs `docker container ls | grep rancher | awk '{ print $1 }'`  2>&1 | grep "Bootstrap Password:"


openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
openssl x509 -req -extfile <(printf "subjectAltName=DNS:gitlab.mn.sipam.gov.br") -days 3650 -in gitlab.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out gitlab.crt
openssl x509 -req -extfile <(printf "subjectAltName=DNS:gitlab.mn.sipam.gov.br") -days 3650 -in gitlab.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out gitlab.crt
openssl x509 -req -extfile <(printf "subjectAltName=DNS:gitlab.mn.sipam.gov.br") -days 3650 -in gitlab.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out gitlab.crt



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

## Set modules and kernel 
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


## Install Kubernetes
    sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2

    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

    sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update

    sudo apt install -y kubectl=1.24.11-00 kubeadm=1.24.11-00 kubelet=1.24.11-00
    sudo apt-mark hold kubelet kubectl kubeadm

## Setup containerd
    containerd config default | tee /etc/containerd/config.toml
    sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml  
    service containerd restart
    service kubelet restart  

## Kubernetes cluster setup
    mkdir -p /run/flannel
    cat > /run/flannel/subnet.env << EOF
        FLANNEL_NETWORK=10.240.0.0/16
        FLANNEL_SUBNET=10.240.0.1/24
        FLANNEL_MTU=1450
        FLANNEL_IPMASQ=true
    EOF

    kubeadm init --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=172.20.5.101:6443 --apiserver-advertise-address=172.20.5.101 --node-name teste-gorayeb-master1 --upload-certs 

    *Important* to take notes of the commands to add new master node and worker nodes on the cluster.
    Before, you can use the new cluster you need to run the following as a regular user or other user you prefer:

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


## Worker node

    Get the command to add the worker node to cluster on kubeadm result.


## Import to rancher

    After the nodes (master and worker) are ready, you need to import the new cluster into rancher. Use the commands suggested by rancher.

## Certificates Install
  copy your domain .crt file to /etc/docker/<your_domain>:<your_domain_port>/
  copy your domain .crt file to /usr/local/share/ca-certificates/
  update-ca-certificates
  service docker restart
  service containerd restart


## GitLab Runner Install
    curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"
    dpkg -i gitlab-runner_amd64.deb
    useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
    gitlab-runner register --url https://gitlab.mn.sipam.gov.br/ --registration-token $REGISTRATION_TOKEN
    chmod 666 /var/run/docker.sock

    To troubleshoot Shell profile loading error , check /home/gitlab-runner/.bash_logout. For example, if the .bash_logout file has a script section like the following, comment it out and restart the pipeline:

    if [ "$SHLVL" = 1 ]; then
        [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
    fi

## Helm Install 
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm -y

## Gitlab CI to Kubernetes Cluster
    *This command changes on every cluster setup*


    docker run --pull=always --rm  registry.gitlab.com/gitlab-org/cluster-integration/gitlab-agent/cli:stable generate   --agent-token="E2i5YJbsK8aD31rUy7qAN74UesejJLZtpYnnkgVjx7uX3iHxAQ"  --kas-address="wss://gitlab.mn.sipam.gov.br/-/kubernetes-agent/"  --agent-version stable  --namespace gitlab-agent-prod >kas.yaml

    kubectl create secret generic 'ca' --namespace gitlab-kubernetes-agent --from-file="${YOUR_CA}.crt"

    kubectl apply -f kas.yaml

    In the kind: Deployment deployment section add the following things:

    In spec:template:spec:containers:args append - --ca-cert-file=/certs/${YOUR_CA}.crt - expand ${YOUR_CA} here manually
    In spec:template:spec:contaiers:volumeMounts add a new block:

    - name: custom-certs
    readOnly: true
    mountPath: /certs

    In spec:template:spec:volumes add a new block:

    - name: custom-certs
    secret:
        secretName: ca

## Failed to pull image certificate signed by unknown authority when pull from a private registry.

  copy your domain .crt file to /etc/docker/<your_domain>:<your_domain_port>/
  copy your domain .crt file to /usr/local/share/ca-certificates/
  update-ca-certificates
  service docker restart
  service containerd restart

## Taint/Untaint Nodes
kubectl describe node teste-gorayeb-master1 | grep Taints
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/control-plane:NoSchedule-
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule-
kubectl taint nodes teste-gorayeb-master1 node-role.kubernetes.io/master:NoSchedule