
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "master" ]; then

  echo "Deploying master branch update..."
  echo "Host: $MASTER_INSTALL_HOST"

  echo "Updating GreenSense plug and play on remote host..."

  sshpass -p $MASTER_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $MASTER_INSTALL_SSH_USERNAME@$MASTER_INSTALL_HOST "wget --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH_NAME/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH_NAME"
  
  echo "Giving services time to start..."
  sleep 30
  
  echo "Checking deployment..."
  bash check-deployment.sh

  echo "Finished deployment."
else
  echo "You're not in the master branch. Skipping master deployment."
fi
