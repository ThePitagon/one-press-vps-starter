#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

echo 'Setting auto-update time...'

sudo timedatectl set-timezone Asia/Ho_Chi_Minh
sudo apt install -y chrony
sudo sed -i 's|^pool .*|pool time.nist.gov iburst|' /etc/chrony/chrony.conf
sudo systemctl enable --now chrony
sudo systemctl restart chrony

echo 'Setting auto-update time... DONE'