
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]; then

  echo "Deploying dev branch update..."

  echo ""
  
  echo "Waiting for deployment to unlock..."
  . ./detect-deployment-details.sh
  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GreenSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."
  
  echo ""
  
  echo "Updating GreenSense plug and play on remote computer..."
  
  echo "Host: $DEV_INSTALL_HOST"

  sshpass -p $DEV_INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $DEV_INSTALL_SSH_USERNAME@$DEV_INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GreenSense/Index/$BRANCH/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH" || exit 1

  echo ""
  
#  START_WAIT_TIME=40
#  echo "Giving services time to start ($START_WAIT_TIME seconds)..."
#  sleep $START_WAIT_TIME
  
#  echo ""
  
  echo "Checking deployment..."
  bash check-deployment.sh || exit 1
  
  echo ""
  
  echo "Finished deployment."
else
  echo "You're not in the dev branch. Skipping dev deployment."
fi
