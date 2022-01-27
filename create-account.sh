#!/bin/bash

if ! [[ $(id -u) == 0 ]]; then
  echo 'Error: you need to run as root.'
  exit 1
fi

# create the ross2 account if it does not exist
getent passwd ross2 > /dev/null
if [ $? -ne 0 ]
then
    echo "Creating ross2 account ..."
	useradd -m -s /bin/bash ross2
else
    echo "ross2 account exists - skipping creation"
fi

# add account to the sudoers file if it does not exist
cat /etc/sudoers|grep ^ross2 > /dev/null
if [ $? -ne 0 ]
then
    echo "Adding ross2 account to the sudoers file ..."
	echo "ross2        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
	echo "Defaults:ross2 !requiretty" >> /etc/sudoers
else
    echo "ross2 account already in sudoers file - skipping"
fi

# configure the ssh pub key for login if it does not exist
if [ ! -s /home/ross2/.ssh/authorized_keys ]
then
    if [ ! -d /home/ross2/.ssh ]
	then
		echo "Creating .ssh directory ..."
		mkdir /home/ross2/.ssh
	else
	 	echo ".ssh directory already exists - skipping"
	fi

    # create the authorized key file for access
	# the public key configuration will allow ansible
	# to run in push mode if necessary.
    echo "Adding authorized_keys file ..."
	curl -o /home/ross2/.ssh/authorized_keys https://gitlab.com/rolston/pubssh/raw/master/id_rsa.pub
	chown ross2:ross2 -R /home/ross2/.ssh
	chmod 600 /home/ross2/.ssh/authorized_keys
else
	echo "authorized_key file already exists - skipping"
fi

