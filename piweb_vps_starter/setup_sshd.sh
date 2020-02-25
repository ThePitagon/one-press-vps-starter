#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

SSH_PORT=$1

[ -z "$SSH_PORT" ] && SSH_PORT=22

echo 'Setting up SSH service...'

if [ "$SSH_PORT" != "22" ]; then
	echo 'Changing SSH port...'
	# If SSH port difference than 22, configure new SSH port
	# Here you need to change "#Port 22" for fit with your current SSH configuration
	sudo sed -i -e 's/'"#Port 22"'/'"Port $SSH_PORT"'/g' /etc/ssh/sshd_config
	sudo yum install -y policycoreutils-python selinux-policy-targeted
	sudo semanage port -a -t ssh_port_t -p tcp $SSH_PORT
	sudo systemctl restart sshd
fi

echo 'Adding SSH port to iptables...'

# Add SSH port to firewall
sudo iptables -I INPUT -p tcp -m tcp --dport $SSH_PORT -j ACCEPT
sudo iptables -I INPUT -p tcp --dport $SSH_PORT -m state --state NEW -m recent --set --name ssh --rsource
sudo iptables -I INPUT -p tcp --dport $SSH_PORT -m state --state NEW -m recent ! --rcheck --seconds 60 --hitcount 4 --name ssh --rsource -j ACCEPT
sudo iptables-save | sudo tee /etc/sysconfig/iptables
sudo service iptables restart

echo 'Setting up SSH service... DONE'
