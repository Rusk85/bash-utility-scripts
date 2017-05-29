#!/bin/bash
# Create Git Repository using latest official Github .gitignore for Visual Studio Projects

# RELEASE
set -euo pipefail
# DEBUG
#set -euox pipefail

usage()
{
	echo -e "This script creates a git repository with the newest VisualStudio.gitignore file downloaded from github."
	echo -e "For downloading curl is used and needs to be installed.\n"
	echo -e "Usage:"
	echo -e "Script requires two arguments"
	echo -e "#1(mandatory):	New Git Repository Name as in 'git init repo_name'"
	echo -e "#2(optional):	In case a proxy is required, set required values in proxy.cfg and pass password as 2nd argument to script\n"
	echo -e "Note: If password contains characters with special meaning in Bash such as '\$' make sure to escape these on input.\n"
	exit 0;
}

if [ "$#" -gt 2 ] || [ "$#" -eq 0 ] ; then
	usage
fi

if [ "$#" -eq 1 ] ; then
	if [ "$1" == "--help" ] || [ "$1" == "-h" ] ; then
		usage
	fi
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CURL_PROXY=""
if [ "$#" -eq 2 ] ; then
	source ${SCRIPT_DIR}/proxy.cfg
	CURL_PROXY="${PROXY_SCHEME}${PROXY_USER}:$2@${PROXY_NAME}"
fi

VS_GITIGNORE="https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore"

CUR_DIR=$(pwd)
NAME_REPO=$1
PATH_REPO=$CUR_DIR/$NAME_REPO
CURL_OUTPUT=${PATH_REPO}/.gitignore

get_gitignore()
{
	local curl_proxy="-x "
	local curl_cmd="curl -k -o ${CURL_OUTPUT}"
	if [ "$CURL_PROXY" != "" ] ; then
        CURL_PROXY=$(echo $CURL_PROXY | sed -e 's/[]\/$*.^|[]/\\&/g')
		curl_cmd="$curl_cmd -x $CURL_PROXY"
	fi
	curl_cmd="$curl_cmd $VS_GITIGNORE"
	eval $curl_cmd
}

echo -e "Initializing Git Repository...\n"
git init $CUR_DIR/$NAME_REPO

echo -e "Adding latest VisualStudio.gitignore to new Git Repository '$NAME_REPO'...\n"
get_gitignore

echo -e "Changing into new Git Repo and creating initial commit...\n"
cd $PATH_REPO
git add .
git commit -m "Initial Commit"

echo -e "Finished..."
