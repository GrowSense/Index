
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')

if [ "$BRANCH" = "dev" ]; then

  echo "Deploying dev branch update..."

  echo ""
  
  echo "Waiting for deployment to unlock..."
  . ./detect-deployment-details.sh
  sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "cd /usr/local/GrowSense/Index && bash wait-for-unlock.sh" || echo "Failed to wait for unlock. Script likely doesn't exist because it hasn't been installed."
  
  echo ""
  
  echo "Updating GrowSense plug and play on remote computer..."
  
  echo "Host: $INSTALL_HOST"

  if sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "[ -d /usr/local/GrowSense/Index ]"; then
    sshpass -p $INSTALL_SSH_PASSWORD ssh -o "StrictHostKeyChecking no" $INSTALL_SSH_USERNAME@$INSTALL_HOST "wget -q --no-cache -O - https://raw.githubusercontent.com/GrowSense/Index/$BRANCH/scripts-web/update-plug-and-play-from-web.sh | bash -s -- $BRANCH" || exit 1

    echo ""
    
    echo "Checking deployment..."
    bash check-deployment.sh || exit 1
    
    echo ""
    echo "Finished deploying update"
  else
    echo "  GrowSense isn't installed. Skipping update."
  fi

  
else
  echo "You're not in the dev branch. Skipping dev deployment."
fi
