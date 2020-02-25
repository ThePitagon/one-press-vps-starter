#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

echo 'Setting up iptables...'

# Disable firewalld on CentOS 7
sudo systemctl stop firewalld
sudo systemctl disable firewalld
# Install iptables
sudo yum install -y iptables-services
sudo systemctl start iptables
sudo systemctl status iptables
sudo systemctl enable iptables

echo 'Setting up basic policies...'

# Basic rules
sudo iptables -F
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp -m multiport --dport 80,443 -j ACCEPT
sudo iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P INPUT DROP
# Save configuration
sudo iptables-save | sudo tee /etc/sysconfig/iptables
# Apply changes
sudo systemctl restart iptables

echo 'Setting up iptables... DONE'
