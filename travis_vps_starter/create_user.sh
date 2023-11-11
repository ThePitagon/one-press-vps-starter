#!/bin/bash
#
# @author: Travis Tran
# @website: https://travistran.me
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

# Create Google Authenticator and write output to file. After setup completed, you could nano the output file for details.
sudo dnf install -y epel-release
sudo dnf install -y google-authenticator qrencode qrencode-libs
sudo runuser -l $ADMIN_USER -c 'cd ~'
sudo runuser -l $ADMIN_USER -c 'echo -1 | google-authenticator -t -d -f -r 3 -R 30 -w 3 -s ~/.ssh/google_authenticator >> ~/.ssh/google_authenticator.out'

# Update PAM
cat <<EOT >> /etc/pam.d/sshd
# Google Authenticator
auth       required     pam_google_authenticator.so secret=${HOME}/.ssh/google_authenticator
auth       required     pam_permit.so
EOT

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

sudo sed -i -e 's/'"ChallengeResponseAuthentication yes"'/'"#ChallengeResponseAuthentication yes"'/g' /etc/ssh/sshd_config
sudo sed -i -e 's/'"ChallengeResponseAuthentication no"'/'"#ChallengeResponseAuthentication yes"'/g' /etc/ssh/sshd_config

sudo sed -i -e 's/'"#UsePAM no"'/'"UsePAM yes"'/g' /etc/ssh/sshd_config

cat <<EOT >> /etc/ssh/sshd_config

ChallengeResponseAuthentication yes
#AuthenticationMethods publickey,password publickey,keyboard-interactive

EOT

# Restart SSH service to apply changes.
sudo systemctl restart sshd

echo 'Creating admin user $ADMIN_USER... DONE'
