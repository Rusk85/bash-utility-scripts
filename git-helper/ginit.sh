#!/bin/bash
# Create Git Repository using latest official Github .gitignore for Visual Studio Projects

# RELEASE
set -euo pipefail
# DEBUG
#set -euox pipefail


if [ "$#" -ne 2 ] ; then
	echo -e "Usage:\n"
	echo -e "Script requires two arguments\n"
	echo -e "#1: Windows Logon Password\n"
	echo -e "#2: Git Repository Name\n"
	exit 0;
fi

CUR_DIR=$(pwd)
GIT_PROXY=$HOME/toggle-git-proxy.sh
PASSWORD=$1
NAME_REPO=$2
GITIGNORE_REPO=$GR/git-local/3rdPartyProjects/gitignore
GITIGNORE_FILE=$GITIGNORE_REPO/VisualStudio.gitignore


echo -e "Initializing Git Repository...\n"
git init $CUR_DIR/$2

echo -e "Enabling git proxy...\n"
cd $GITIGNORE_REPO/
sh $GIT_PROXY $1
echo -e "Updating VisualStudio.ignore Repository from Origin...\n"
git pull origin

echo -e "Disabling git proxy...\n"
sh $GIT_PROXY

echo -e "Copying $GITIGNORE_FILE to new Git Repository '$NAME_REPO'...\n"
cp -v $GITIGNORE_FILE $CUR_DIR/$2/.gitignore

echo -e "Changing into new Git Repo and creating initial commit...\n"
cd $CUR_DIR/$2
git add .
git commit -m "Initial Commit"

echo -e "Finished..."
