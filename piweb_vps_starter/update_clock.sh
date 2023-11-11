#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

echo 'Setting auto-update time...'

sudo rm -rf /etc/localtime
# Change to your locale as needed
sudo ln -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

sudo cat <<EOT >> /etc/sysconfig/clock

ZONE="Asia/Ho_Chi_Minh"
UTC=false
ARC=false

EOT

sudo hwclock --systohc --localtime
sudo hwclock

# Synchronize local time with global time from internet
sudo dnf -y install chrony
sudo sed -i -e 's/'"pool 2.centos.pool.ntp.org iburst"'/'"pool time.nist.gov iburst"'/g' /etc/chrony.conf
sudo systemctl enable --now chronyd
sudo systemctl restart chronyd

echo 'Setting auto-update time... DONE'
