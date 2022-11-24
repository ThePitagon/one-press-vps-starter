# One Press VPS Starter
<img src="https://img.shields.io/badge/version-1.0-brightgreen">

[<img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white">](https://www.linkedin.com/company/pitagon/)
[<img src="https://img.shields.io/badge/Facebook-1877F2?style=for-the-badge&logo=facebook&logoColor=white">](https://www.facebook.com/ThePitagon/)
[<img src="https://img.shields.io/twitter/follow/ThePitagon.svg?label=Follow&style=social">](https://twitter.com/ThePitagon/)

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

## Support & Feedback
If you still have a question after using One Press VPS Starter, you have a few options.
* Using support page on [Pitagon Website](https://pitagon.io).
* Send email to [Pitagon Support Team](mailto:support@pitagon.vn) for help.
* Connect [Travis Tran on Facebook](https://www.facebook.com/travistran1989) for real-time discussion.
* Reporting any issue on [Github one-press-vps-starter](https://github.com/ThePitagon/one-press-vps-starter/issues) project.

**Pull requests are always welcome**
