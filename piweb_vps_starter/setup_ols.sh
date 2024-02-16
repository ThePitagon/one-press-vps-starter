#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

ADMIN_USER=$1

# Validate arguments
[ -z "$ADMIN_USER" ] && echo "ADMIN_USER is empty. Exiting..." && exit 1

# Setup docker
sudo dnf install -y yum-utils device-mapper-persistent-data lvm2 jq dnf-plugins-core git dnf-utils
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
sudo systemctl start docker

sudo gpasswd -a $ADMIN_USER docker
sudo gpasswd -a ec2-user docker
newgrp docker

# Setup docker-compose
sudo mkdir -p /usr/local/lib/docker/cli-plugins/
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION
docker-compose --version
sudo ln -s /usr/local/bin/docker-compose /usr/bin/

# Setup OLS
# sudo runuser -l $ADMIN_USER -c 'git clone https://github.com/travistran1989/ols-docker-env.git ~/'
# sudo runuser -l $ADMIN_USER -c 'cd ~/ols-docker-env'
# sudo runuser -l $ADMIN_USER -c 'docker-compose -f ~/ols-docker-env/docker-compose.yml up -d'

echo 'Setting OpenLightSpeed... DONE'
