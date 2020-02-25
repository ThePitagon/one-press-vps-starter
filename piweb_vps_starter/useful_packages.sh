#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

echo 'Installing useful packages...'

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

sudo yum -y install nc telnet traceroute gcc make pcre pcre-devel openssl libcurl libcurl-devel rpm nano tar zip unzip

echo 'Installing useful packages... DONE'
