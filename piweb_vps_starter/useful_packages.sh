#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

echo 'Installing useful packages...'

sudo yum install -y epel-release
sudo yum install -y nc telnet traceroute gcc make pcre pcre-devel openssl libcurl libcurl-devel rpm nano tar zip unzip net-tools bind-utils git

sudo yum install -y cronie
sudo systemctl start crond
sudo systemctl enable crond
sudo systemctl status crond

echo 'Installing useful packages... DONE'
