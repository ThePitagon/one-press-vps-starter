# one-press-vps-starter
Setup a new vps with 3 security layers

# Usage
## Preparation
1. Copy folder `travis_vps_starter` to your server directory.
2. Generate a key-pair with passphrase in client machine then copy public key to your server in `travis_vps_starter` directory. Example, in Mac OS, you could generate key-pair by the following command:
`ssh-keygen -t rsa -C "email@domain.com"`
## Execution
1. Grant execute permission for current user by following command:
`chmod +x travis_vps_starter.sh`
2. Execute the following .sh file:
`./travis_vps_starter.sh -u "admin" -k "id_rsa.pub" -p 1989`
In there:
`-u`: username of account with administration rights.
`-k`: file name of public key, in the same folder with executed .sh file.
`-p`: SSH port

# Test
See `test.log` for example output.
