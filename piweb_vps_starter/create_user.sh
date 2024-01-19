#!/bin/bash
#
# @author: Travis Tran
# @website: https://truong.id
# @notice: run as root

ADMIN_USER=$1
ADMIN_PASSWORD=$2
PUB_KEY=$3

# Validate arguments
[ -z "$ADMIN_USER" ] && echo "ADMIN_USER is empty. Exiting..." && exit 1
[ -z "$PUB_KEY" ] && echo "PUB_KEY is empty. Exiting..." && exit 1

echo 'Creating admin user $ADMIN_USER...'

# Create user
sudo adduser $ADMIN_USER
# Add user to group wheel
sudo gpasswd -a $ADMIN_USER wheel
# Set password for user.
sudo echo -e "$ADMIN_PASSWORD\n$ADMIN_PASSWORD" | sudo passwd $ADMIN_USER

# Create .ssh directory for public key authentication
sudo runuser -l $ADMIN_USER -c 'mkdir -p ~/.ssh'
sudo runuser -l $ADMIN_USER -c 'chmod 700 ~/.ssh'
sudo runuser -l $ADMIN_USER -c 'touch ~/.ssh/authorized_keys'
sudo runuser -l $ADMIN_USER -c 'chmod 600 ~/.ssh/authorized_keys'
# Copy public key to .ssh folder
sudo cp $PUB_KEY '/home/'"$ADMIN_USER"'/.ssh/'
# Change owner to new user
sudo chown "$ADMIN_USER"'.' '/home/'"$ADMIN_USER"'/.ssh/'"$PUB_KEY"
# Append key file to store. Here you could delete key file after appending.
sudo runuser -l $ADMIN_USER -c 'cat ~/.ssh/'"$PUB_KEY"' >> ~/.ssh/authorized_keys'

# Change SSH configuration for 3 layers security: public key, password and Google Authenticator
sudo sed -i -e 's/'"#PermitRootLogin no"'/'"PermitRootLogin no"'/g' /etc/ssh/sshd_config
sudo sed -i -e 's/'"PermitRootLogin yes"'/'"PermitRootLogin no"'/g' /etc/ssh/sshd_config

sudo sed -i -e 's/'"#StrictModes yes"'/'"StrictModes yes"'/g' /etc/ssh/sshd_config
sudo sed -i -e 's/'"StrictModes no"'/'"StrictModes yes"'/g' /etc/ssh/sshd_config

sudo sed -i -e 's/'"#PubkeyAuthentication yes"'/'"PubkeyAuthentication yes"'/g' /etc/ssh/sshd_config
sudo sed -i -e 's/'"PubkeyAuthentication no"'/'"PubkeyAuthentication yes"'/g' /etc/ssh/sshd_config

sudo sed -i -e 's/'"#PasswordAuthentication no"'/'"PasswordAuthentication no"'/g' /etc/ssh/sshd_config
sudo sed -i -e 's/'"PasswordAuthentication yes"'/'"PasswordAuthentication no"'/g' /etc/ssh/sshd_config

sudo sed -i -e 's/'"#PermitEmptyPasswords no"'/'"PermitEmptyPasswords no"'/g' /etc/ssh/sshd_config
sudo sed -i -e 's/'"PermitEmptyPasswords yes"'/'"PermitEmptyPasswords no"'/g' /etc/ssh/sshd_config

sudo cat <<EOT >> /etc/ssh/sshd_config

AuthenticationMethods publickey

EOT

# Restart SSH service to apply changes.
sudo systemctl restart sshd

echo 'Creating admin user $ADMIN_USER... DONE'
