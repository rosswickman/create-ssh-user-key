#!/bin/bash

if ! [[ $(id -u) == 0 ]]; then
  echo 'Error: you need to run as root.'
  exit 1
fi

# create the new account if it does not exist
getent passwd ${username} > /dev/null

if [ $? -ne 0 ]
then
  echo "Creating new account ..."
	useradd -m -s /bin/bash ${username}
else
  echo "this user account exists - skipping creation"
fi

# add account to the sudoers file if it does not exist
cat /etc/sudoers|grep ^${username} > /dev/null

if [ $? -ne 0 ]
then
  echo "Adding new user account to the sudoers file ..."
	echo "${username}       ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
	echo "Defaults:${username} !requiretty" >> /etc/sudoers
else
  echo "New user account already in sudoers file - skipping"
fi

# configure the ssh pub key for login if it does not exist

if [ ! -s /home/${username}/.ssh/authorized_keys ]
then
  if [ ! -d /home/${username}/.ssh ]
	then
		echo "Creating .ssh directory ..."
		mkdir /home/${username}/.ssh
	else
	 	echo ".ssh directory already exists - skipping"
	fi

  # create the authorized key file for access
	# the public key configuration will allow ansible
	# to run in push mode if necessary.

  echo "Adding authorized_keys file ..."

	curl -o /home/${username}/.ssh/authorized_keys https://github.com/rosswickman/create-ssh-user-key/raw/master/keys/${username}.pub
	chown ${username}:${username} -R /home/${username}/.ssh
	chmod 600 /home/${username}/.ssh/authorized_keys

else
	echo "authorized_key file already exists - skipping"
fi

