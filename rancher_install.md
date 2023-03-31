## Install Docker 20.10 (https://www.suse.com/assets/v2.5.16-Support-Matrix.pdf)



## Setup sysctl options for Docker
cat > /etc/sysctl.d/10-iptables.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl -p

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





# Registry
 - need to add gitlab certificates to docker host running gitlab-runner on
   /etc/docker/certs.d/
 - restart docker
 - enable it on /etc/gitlab/gitlab.rb
 - gitlab-ctl reconfigure

# GitLab Runner Install
curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb"
dpkg -i gitlab-runner_amd64.deb
useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
gitlab-runner register --url https://gitlab.mn.sipam.gov.br/ --registration-token $REGISTRATION_TOKEN
chmod 666 /var/run/docker.sock

  To troubleshoot Shell profile loading error , check /home/gitlab-runner/.bash_logout. For example, if the .bash_logout file has a script section like the following, comment it out and restart the pipeline:

  if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
  fi




### Failed to pull image certificate signed by unknown authority when pull from a private registry.

  copy your domain .crt file to /etc/docker/<your_domain>:<your_domain_port>/
  copy your domain .crt file to /usr/local/share/ca-certificates/
  update-ca-certificates
  service docker restart
  service containerd restart


