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
	echo -e "#2(optional):	Proxy of format <[protocol://][user:password@]proxyhost[:port]>"
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


CURL_PROXY=""
if [ "$#" -eq 2 ] ; then
	CURL_PROXY=$2
fi

VS_GITIGNORE="https://raw.githubusercontent.com/github/gitignore/master/VisualStudio.gitignore"

CUR_DIR=$(pwd)
NAME_REPO=$1
PATH_REPO=$CUR_DIR/$NAME_REPO
CURL_OUTPUT=${PATH_REPO}/.gitignore

get_gitignore()
{
	local curl_proxy="-x "
	local curl_cmd="curl -o ${CURL_OUTPUT}"
	if [ "$CURL_PROXY" != "" ] ; then
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
