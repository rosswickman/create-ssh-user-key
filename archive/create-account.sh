#!/bin/bash

if ! [[ $(id -u) == 0 ]]; then
  echo 'Error: you need to run as root.'
  exit 1
fi

# create the grolston account if it does not exist
getent passwd grolston > /dev/null
if [ $? -ne 0 ]
then
    echo "Creating grolston account ..."
	useradd -m -s /bin/bash grolston
else
    echo "grolston account exists - skipping creation"
fi

# add account to the sudoers file if it does not exist
cat /etc/sudoers|grep ^grolston > /dev/null
if [ $? -ne 0 ]
then
    echo "Adding grolston account to the sudoers file ..."
	echo "grolston        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
	echo "Defaults:grolston !requiretty" >> /etc/sudoers
else
    echo "grolston account already in sudoers file - skipping"
fi

# configure the ssh pub key for login if it does not exist
if [ ! -s /home/grolston/.ssh/authorized_keys ]
then
    if [ ! -d /home/grolston/.ssh ]
	then 
		echo "Creating .ssh directory ..."
		mkdir /home/grolston/.ssh
	else
	 	echo ".ssh directory already exists - skipping"
	fi
    
    # create the authorized key file for access
	# the public key configuration will allow ansible
	# to run in push mode if necessary.
    echo "Adding authorized_keys file ..."
	curl -o /home/grolston/.ssh/authorized_keys https://gitlab.com/rolston/pubssh/raw/master/id_rsa.pub
	chown grolston:grolston -R /home/grolston/.ssh
	chmod 600 /home/grolston/.ssh/authorized_keys
else
	echo "authorized_key file already exists - skipping"
fi

