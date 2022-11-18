#!/bin/bash

# This script will make a copy of the local code, load keys, clone the repo locally, and restart the service

# Assumes that the repo and keys are in the current directory and the code is running as a systemd service

echo "checking for old directory/version"
if [ -d "nnSlackBot_old" ]; then
	rm -rf nnSlackBot_old
	mv nnSlackBot ./nnSlackBot_old
	echo "deleted older version"
else
	mv nnSlackBot ./nnSlackBot_old
	echo "No previous version found, creating backup of current version"
fi
eval `ssh-agent`
ssh-add ./nnslackbot_ssh-key_github
git clone git@github.com:adamfitz/nnSlackBot.git
echo "copying local creds file back to running directory"
cp ./nnSlackBot_old/credentials ./nnSlackBot
systemctl restart nnslackbot