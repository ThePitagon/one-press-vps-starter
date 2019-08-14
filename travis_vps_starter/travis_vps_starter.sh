#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
# @notice: run as root

# Read arguments
while getopts ":u:k:p:" opt; do
  case $opt in
    u) ADMIN_USER="$OPTARG"
    ;;
    k) PUB_KEY="$OPTARG"
    ;;
    p) SSH_PORT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

echo 'Starting set up VPS...'

[ -z "$SSH_PORT" ] && SSH_PORT=1989
[ -z "$ADMIN_USER" ] && ADMIN_USER=adminUser

# Update OS
chmod +x update_os.sh
./update_os.sh

# Install some useful packages
chmod +x useful_packages.sh
./useful_packages.sh

# Automatically update clock
chmod +x update_clock.sh
./update_clock.sh

# Setup iptables
chmod +x setup_iptables.sh
./setup_iptables.sh

# Setup SSH configuration
chmod +x setup_sshd.sh
./setup_sshd.sh $SSH_PORT

# Create user with administrator rights
chmod +x create_user.sh
./create_user.sh $ADMIN_USER $PUB_KEY

echo 'Setting up VPS all DONE.'
