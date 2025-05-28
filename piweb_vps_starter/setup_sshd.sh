#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

SSH_PORT=$1

[ -z "$SSH_PORT" ] && SSH_PORT=22

echo 'Setting up SSH service...'

sudo apt install -y openssh-server

if [ "$SSH_PORT" != "22" ]; then
	echo 'Changing SSH port...'
  echo "Changing SSH port to $SSH_PORT..."
  sudo sed -i "s/^#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config
  sudo sed -i "s/^Port .*/Port $SSH_PORT/"    /etc/ssh/sshd_config
  sudo systemctl restart ssh
fi

echo 'Adding SSH port to iptables...'

# Add SSH port to firewall
iptables -I INPUT -p tcp -m tcp --dport $SSH_PORT -j ACCEPT
iptables -I INPUT -p tcp --dport $SSH_PORT -m state --state NEW -m recent --set --name ssh --rsource
iptables -I INPUT -p tcp --dport $SSH_PORT -m state --state NEW -m recent ! --rcheck --seconds 60 --hitcount 4 --name ssh --rsource -j ACCEPT

netfilter-persistent save
netfilter-persistent reload

echo 'Setting up SSH service... DONE'
