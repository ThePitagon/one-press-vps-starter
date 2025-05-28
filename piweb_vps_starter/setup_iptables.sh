#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

echo 'Setting up iptables...'

sudo apt install -y iptables iptables-persistent
sudo iptables -F

sudo iptables -A INPUT  -p tcp --tcp-flags ALL NONE   -j DROP
sudo iptables -A INPUT  -p tcp ! --syn -m state --state NEW -j DROP
sudo iptables -A INPUT  -p tcp --tcp-flags ALL ALL    -j DROP
sudo iptables -A INPUT  -i lo -j ACCEPT
sudo iptables -A INPUT  -p tcp -m multiport --dport 80,443 -j ACCEPT
sudo iptables -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT

sudo iptables -P OUTPUT ACCEPT
sudo iptables -P INPUT  DROP

sudo netfilter-persistent save
sudo netfilter-persistent reload

echo 'Setting up iptables... DONE'
