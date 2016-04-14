#!/usr/bin/env bash

# sets up environment variables for a sufia instance
function usage
{
  echo "usage: env_vars [[[-a ADMIN ] [-u APPLICATION_USER]] [-n APPLICATION_NAME]] | [-h]]"
}

# set defaults:
ADMIN="vagrant"
ADMIN_HOME="/home/$ADMIN"

APPLICATION_USER="sufia"
APPLICATION_NAME="newsletter-demo"
APPLICATION_INSTALL_LOCATION="/opt/$APPLICATION_NAME"
VAR_FILE="$APPLICATION_INSTALL_LOCATION/.rbenv-vars"

# process arguments:
while [ "$1" != "" ]; do
  case $1 in
    -a | --admin )    shift
                      ADMIN=$1
                      ;;
    -u | --user )     APPLICATION_USER=$1
                      ;;
    -n | --name )     APPLICATION_NAME=$1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

if [ ! -f $ADMIN_HOME/.provisioning-progress ]; then
  touch $ADMIN_HOME/.provisioning-progress
  echo "--> Progress file created in $ADMIN_HOME/.provision-progress"
else
  echo "--> Progress file exists in $ADMIN_HOME/.provisioning-progress"
fi

if grep -q +env_vars $ADMIN_HOME/.provisioning-progress; then
  echo "--> Environment vars already configured, moving on."
else
  echo "--> Configuring environment vars..."

	if [ ! -f "$VAR_FILE" ]; then
		sudo su - $APPLICATION_USER bash -c "touch $VAR_FILE"
		echo "--> Environment variables file created in $VAR_FILE"
	else
		echo "--> Environment variables file exists in $VAR_FILE"
	fi

  sudo su - $APPLICATION_USER bash -c "cd $APPLICATION_INSTALL_LOCATION && echo \"SECRET_KEY_BASE=\$(bundle exec rake secret)\" >> $VAR_FILE"

	echo +env_vars >> $ADMIN_HOME/.provisioning-progress
	echo "--> Environment vars now configured."
fi