#!/bin/bash
# Generating rsa private/public keypair without passphrase 
# and storing in Users home directory (~/.ssh)
# Usage
# Mode 1: ./create-ssh-key		; with no parameters a key pair with a random name is generated
# Mode 2: ./create-ssh-key keyname	; sets name of key (optional)
# Mode 3: ./create-ssh-key -n		; runs in dry mode where keys are actually created but afterwards removed
# Mode 4: ./create-ssh-key keyname -n	; runs as in Mode 3 but with a specific key name



set -euo pipefail
# uncomment for debugging
#set -euox pipefail

KEYNAME=""
ARG_DRY_RUN=-n
DRY_RUN=false
HR="\n$(head -c 93 < /dev/zero | tr '\0' '*')\n"

# generate uniqe keyname
generate_keyname()
{
	printf "\nGenerating random keyname\n .."
	local key_prefix=id_rsa
	local host=$(hostname)
	local day_of_year=$(date +%j)
	local random_string=$(tr -d \= <<< $(openssl rand -base64 8))
	KEYNAME=$key_prefix.$host.$day_of_year.$random_string
	printf "\nKeyname was generated as $KEYNAME ..\n"
}

eexit()
{
	exit 1
}

error_usage_n()
{
	printf "\nUnkown option $1. Expected $ARG_DRY_RUN."
	printf "\Aborting execution .."
	eexit
}

error_usage_args()
{
	printf "\nToo many arguments specified."
	printf "\nAborting execution .."
	eexit
}

error_unknown()
{
	printf "\nUnknown error occured."
	printf "\nAborting execution .."
	eexit
}


dryrun()
{
	DRY_RUN=true
	printf "\nRunning key generation in test mode."
	printf "\nNo actual key will be generated."
}

no_dryrun()
{
	DRY_RUN=false
}

cleanup_dryrun()
{
	printf "\nRemoving generated key files during dry run .."
	printf "\nPrivate Key: $KEYNAME"
	printf "\nPublic key: $KEYNAME_PUBLIC"
	rm -fv $OUTPUT_PATH_PRIVATE
	rm -fv $OUTPUT_PATH_PUBLIC
	printf "\nDuring dry run generated keys sucessfully removed"
}


if [ "$#" -eq 1 ] && [ "$1" == "$ARG_DRY_RUN" ] ; then

	dryrun
	generate_keyname

elif [ "$#" -eq 1 ] && [ "$1" != "$ARG_DRY_RUN" ] ; then

	no_dryrun
	KEYNAME=$1
	

elif [ "$#" -eq 2 ] && [ "$2" == "$ARG_DRY_RUN" ] ; then

	dryrun
	generate_keyname

elif [ "$#" -eq 2 ] && [ "$2" != "$ARG_DRY_RUN" ] ; then

	no_dryrun
	error_usage_n $2
	
elif [ "$#" -gt 2 ] ; then

	error_usage_args	


elif [ "$#" -eq 0 ] ; then
	
	no_dryrun
	generate_keyname	

else
	no_dryrun
	error_unknown

fi

KEY_PUBLIC_EXT=pub
KEYNAME_PUBLIC=$KEYNAME.$KEY_PUBLIC_EXT
OUTPUT_DIR=$HOME/.ssh
OUTPUT_PATH_PRIVATE=$OUTPUT_DIR/$KEYNAME
OUTPUT_PATH_PUBLIC=$OUTPUT_PATH_PRIVATE.$KEY_PUBLIC_EXT
printf "Set private key name to '$KEYNAME' and saving to '$OUTPUT_PATH_PRIVATE'\n"
printf "Set public key name to '$KEYNAME_PUBLIC' and saving to '$OUTPUT_PATH_PUBLIC'\n"

ssh-keygen -t rsa -f $OUTPUT_PATH_PRIVATE -N ""

printf "\n\n"
printf "Printing public key to STDIN"
printf "\n"
echo -e $HR
echo -e $(cat $OUTPUT_PATH_PUBLIC)
echo -e $HR


printf "\nNAME OF KEY\n"
echo -e $HR
echo -e "\t\t\t\t $KEYNAME"
echo -e $HR
if [ "$DRY_RUN" == "true" ] ; then
	cleanup_dryrun	
fi


printf "\n\n\n"

