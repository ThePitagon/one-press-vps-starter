#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

echo 'Setting auto-update time...'

sudo rm -rf /etc/localtime
# Change to your locale as needed
sudo ln -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime

cat <<EOT >> /etc/sysconfig/clock

ZONE="Asia/Ho_Chi_Minh"
UTC=false
ARC=false

EOT

sudo hwclock --systohc --localtime
sudo hwclock

# Synchronize local time with global time from internet
sudo yum -y install ntp
sudo systemctl enable ntpd
sudo ntpdate -b -u time.nist.gov
sudo systemctl start ntpd

echo 'Setting auto-update time... DONE'
