#!/bin/bash

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 .travis/id_rsa # Allow read access to the private key
ssh-add .travis/id_rsa # Add the private key to SSH

ssh -o "StrictHostKeyChecking no" $USER@$HOST <<EOF
  echo "halko" > halko
  cd $DEPLOY_DIR
#  git pull origin master 
#  kiex use 1.4.5 
#  make deploy-stop 
#  make deploy
EOF
