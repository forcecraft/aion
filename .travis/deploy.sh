#!/bin/bash

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 .travis/id_rsa # Allow read access to the private key
ssh-add .travis/id_rsa # Add the private key to SSH

ssh -o "StrictHostKeyChecking no" $USER@$HOST /bin/bash <<EOF
  source ~/.bashrc && \
  cd $DEPLOY_DIR && \
  git pull origin master && \
  make deploy
EOF
