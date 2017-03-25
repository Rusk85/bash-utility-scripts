#!/bin/bash
# update .ssh/config with new key

# VERSION 0.1.0.0

# Parameters
# $1: relative path to keyfile
# $2: repository name for aliasing
# $3: HostName
# $4: UserName

# TEMPLATE
# Host github.com-VisualStudioSettings
# HostName github.com
# User Rusk85
# IdentitiesOnly yes
# IdentityFile ~/.ssh/id_rsa.github.VisualStudioSettings

set -eou pipefail

if [ "$#" -ne 4 ] ; then
		printf "\nNot all required arguments specified .."
		printf "\nExample usage: ./update-ssh-config id_rsa myRepositoryName github.com myUserName\n"
		exit 1
fi


# < -- Config File Parameters -- >
HOST=""
HOSTNAME="HostName $3"
USER="User $4"
IDENT_ONLY="IdentitiesOnly yes"
IDENTITYFILE="IdentityFile $HOME/.ssh/$1"


# < -- Paths -- >
CONFIG_PATH="$HOME/.ssh/config"


compose_host_alias()
{
	# Example: github.com -> github.com-VisualStudioSettings
	HOST="Host $1-$2"
}

update_ssh_config()
{
	printf "\n" >> $CONFIG_PATH
	printf "\n$HOST" >> $CONFIG_PATH
	printf "\n\t$HOSTNAME" >> $CONFIG_PATH
	printf "\n\t$USER" >> $CONFIG_PATH
	printf "\n\t$IDENT_ONLY" >> $CONFIG_PATH
	printf "\n\t$IDENTITYFILE" >> $CONFIG_PATH
}

compose_host_alias $3 $2
update_ssh_config


