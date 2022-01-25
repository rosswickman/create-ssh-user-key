# Generate SSH User with Public SSH Key

Creates a user on Instance and deploys a corresponding Public SSH Key.

This setup will create the user account, give it sudo access, and then install the public key under the authorized_keys for account.

## Interactive Install

Run either curl or wget one-liners to install interactively:

### curl

```bash
curl -fsS https://raw.githubusercontent.com/rosswickman/create-ssh-user-key/master/scripts/${username}.sh | sudo bash
```

### wget

```bash
wget https://raw.githubusercontent.com/rosswickman/create-ssh-user-key/master/scripts/${username}.sh? -O- | sudo bash
```

## AWS CloudFormation EC2 UserData

In some cases depending on OS, you may not be able to pipe to sh. Therefore to be sure the installation runs, run one of the following:

### curl

```bash
 cd /root/
 curl -fsS https://raw.githubusercontent.com/rosswickman/create-ssh-user-key/master/scripts/${username}.sh -O
 chmod u+x /root/${username}.sh
 ./${username}.sh

```

### wget

```bash
 cd /root/
 wget https://raw.githubusercontent.com/rosswickman/create-ssh-user-key/master/scripts/${username}.sh
 chmod u+x /root/${username}.sh
 ./${username}.sh
```
