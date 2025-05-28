#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

echo 'Installing useful packages...'

sudo apt install -y software-properties-common
sudo apt install -y \
  telnet traceroute build-essential libpcre3-dev libssl-dev \
  libcurl4-openssl-dev rpm nano tar zip unzip net-tools dnsutils git
sudo apt install -y cron
sudo systemctl enable --now cron

echo 'Installing useful packages... DONE'