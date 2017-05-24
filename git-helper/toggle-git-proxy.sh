#!/bin/bash
#git config --global http.proxy http://U000000:WindowsPwd@mwg7.prodsrz.srzintra.de:81

if [ "$#" -eq 0 ] ; then
	echo -e "\nRemoving proxy setting in git...\n"
	git config --global http.proxy ""
else
	USER=U795005
	PASSWORD=$1
	PROXY="http://$USER:$PASSWORD@mwg7.prodsrz.srzintra.de:81"
	echo -e "\nAdding proxy setting in git...\n"
	git config --global http.proxy $PROXY
fi

RESULT=$(git config --global http.proxy)
echo -e "\n'git config --global http.proxy' set to '$RESULT'\n"
