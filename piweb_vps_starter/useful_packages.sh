#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

echo 'Installing useful packages...'

sudo dnf install -y epel-release
sudo dnf install -y nc telnet traceroute gcc make pcre pcre-devel openssl libcurl libcurl-devel rpm nano tar zip unzip net-tools bind-utils git

echo 'Installing useful packages... DONE'
